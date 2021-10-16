Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815144305AA
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 01:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbhJPX42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 19:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241211AbhJPX42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 19:56:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D649CC061765
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 16:54:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ez7-20020a17090ae14700b001a132a1679bso2099614pjb.0
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 16:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=fuxxn6ZRO+8ECCbjh6IkYfd/4atCOgYZC/5BfYl+Sno=;
        b=B/xNm0+wFRW5Vx0UMOpZAL8kG0PjwdXZP1ELpYJWan3z6CLbTLGBnBQXbXseD40xBa
         AYw9Z4YUnA2QxbAua7WfecHAqNAX0Rdc2G+fbM7i9vFCJbrEJg1q6dTXZUs0xzF1XheB
         +NuRf+2DoeHYIAWo/0s9FpPANR8dPu1YOAT1oGlkzqJG+/aRnP4iZz0G5zhubgaQsun/
         qpDmChMl90nIUYTOGzGThay4pdUYNkZ5aiCbeF5jLqJVZtzHn9fDdAX56br3HZ8Ft96k
         5rkKol/rbo4c4IvKp3j4xxCD0Qn1QyaPp8hU4slI/w4ARlUDJG7iU3Lgl79iRoXT/Qpi
         Ao+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=fuxxn6ZRO+8ECCbjh6IkYfd/4atCOgYZC/5BfYl+Sno=;
        b=cupU+uf6EvA/0zh1UADKJ9c9E86hrz6sfPrdpjWlVC8xMrihyVVtYiEp7vwOTX7msd
         PcRf/nywy/GzxU7ru7UScC5wOFzGfSpJwiPzR/Xw9dyuKdts0JQ0wHFsw8fPArnbtruP
         V7ON4L/bUugRMv4cTW0YxQSbim8bxuJBxUtEda76S7HaDunpSy/9t//Hyb9E7FjNT9cF
         kk3xWCPToybbhZlMsgwmTRIBlgbdR3p1pqjOlCVNXO+NgdIk/oXKWjJX6zsvEjkNxa/H
         IcSCcIzpnT+dvSblLVIHBBL0QT/6ag1Di2RvZfxs3dHAMvMp7VPi37nt2beZZ98er3xj
         S13g==
X-Gm-Message-State: AOAM533i90L4Nq4dr2Kb7k0TiJr+nSJck30bct6LuKjhOayOpYMaU8kn
        Kz/wMDV/y5cBAupWxIoSVENPTYf2VQE2mw==
X-Google-Smtp-Source: ABdhPJypoS7czBxmVLRt/shARPKeWdf+nqJOyHMax6rImTXOpxpKVZ4D+if0NdolPx76PzBoePu/Og==
X-Received: by 2002:a17:90b:3ecd:: with SMTP id rm13mr23357624pjb.189.1634428458815;
        Sat, 16 Oct 2021 16:54:18 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id pj12sm9297988pjb.19.2021.10.16.16.54.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 16:54:18 -0700 (PDT)
Date:   Sat, 16 Oct 2021 16:54:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 214741] New: Information leakage from kernel to user space
 in /net/netrom/af_netrom.c
Message-ID: <20211016165415.3f4e8842@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sat, 16 Oct 2021 21:03:45 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214741] New: Information leakage from kernel to user space in=
 /net/netrom/af_netrom.c


https://bugzilla.kernel.org/show_bug.cgi?id=3D214741

            Bug ID: 214741
           Summary: Information leakage from kernel to user space in
                    /net/netrom/af_netrom.c
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15-rc5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: bao00065@umn.edu
        Regression: No

Hi Maintainers,
I recently reviewed the uninitialized value use bug in Linux kernel:

https://syzkaller.appspot.com/bug?id=3D739ce0bc6e4097668cbf94c862f3b643b364=
d589.=20
and patch:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Db42b3a2744b3e8f427de79896720c72823af91ad

The vulnerable function is:
int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
                      int __user *usockaddr_len)
{
        struct socket *sock;
        struct sockaddr_storage address; // allocation
        int err, fput_needed;

        sock =3D sockfd_lookup_light(fd, &err, &fput_needed);
        if (!sock)
                goto out;

        err =3D security_socket_getsockname(sock);
        if (err)
                goto out_put;

        err =3D sock->ops->getname(sock, (struct sockaddr *)&address, 0); //
initialization
        if (err < 0)
                goto out_put;
        /* "err" is actually length in this case */
        err =3D move_addr_to_user(&address, err, usockaddr, usockaddr_len);=
 //use

out_put:
        fput_light(sock->file, fput_needed);
out:
        return err;
}

static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
                             void __user *uaddr, int __user *ulen)
{
        int err;
        int len;

        BUG_ON(klen > sizeof(struct sockaddr_storage));
        err =3D get_user(len, ulen);
        if (err)
                return err;
        if (len > klen)
                len =3D klen;
        if (len < 0)
                return -EINVAL;
        if (len) {
                if (audit_sockaddr(klen, kaddr))
                        return -ENOMEM;
                if (copy_to_user(uaddr, kaddr, len)) // use=20
                        return -EFAULT;
        }
        /*
         *      "fromlen shall refer to the value before truncation.."
         *                      1003.1g
         */
        return __put_user(klen, ulen);
}


the variable address is allocated in __sys_getsockname, and then is initial=
ized
in sock->ops->getname(sock, (struct sockaddr *)& address, 0); After that,
address is passed to move_addr_to_user() and finally it passed to
copy_to_user(), leading to uninitialized value use.=20

Main reason for this bug: initialization in sock->ops->getname(sock, (struct
sockaddr *)&address, 0) is partially initialized.  It only initializes the
fields in the struct but not the holes between the fields. As a result, sin=
ce
uaddr will be passed to copy_to_user(), and the holes inside the uaddr stru=
ct=20
contain uninitialized data inherited from the kernel stack, it may cause
information leakage from kernel space to user space

Here is the initialization function:

static int isotp_getname(struct socket *sock, struct sockaddr *uaddr, int p=
eer)
{
        struct sockaddr_can *addr =3D (struct sockaddr_can *)uaddr;
        struct sock *sk =3D sock->sk;
        struct isotp_sock *so =3D isotp_sk(sk);

        if (peer)
                return -EOPNOTSUPP;

        +memset(addr, 0, ISOTP_MIN_NAMELEN);//patch
        addr->can_family =3D AF_CAN;
        addr->can_ifindex =3D so->ifindex;
        addr->can_addr.tp.rx_id =3D so->rxid;
        addr->can_addr.tp.tx_id =3D so->txid;

        return ISOTP_MIN_NAMELEN;
}

The patch: memset() initializes the whole struct sockaddr_can, including the
holes within the struct sockaddr_can.

Sockaddr_can is declared here:
struct sockaddr_can {
        __kernel_sa_family_t can_family;
        int         can_ifindex;
        union {
                /* transport protocol class address information (e.g. ISOTP=
) */
                struct { canid_t rx_id, tx_id; } tp;

                /* J1939 address information */
                struct {
                        /* 8 byte name when using dynamic addressing */
                        __u64 name;

                        /* pgn:
                         * 8 bit: PS in PDU2 case, else 0
                         * 8 bit: PF
                         * 1 bit: DP
                         * 1 bit: reserved
                         */
                        __u32 pgn;

                        /* 1 byte address */
                        __u8 addr;
                } j1939;

                /* reserved for future CAN protocols address information */
        } can_addr;
};
There are a few holes inside the struct, but it doesn=E2=80=99t explicitly =
set to 0 in=20
isotp_getname()

At the same time, I realized  sock->ops->getname(sock, (struct sockaddr
*)&address, 0) is an indirect call. Thus it may go to different functions at
the run time. If one of these functions doesn't initialize the holes within=
 the
struct, it may cause an information leak from kernel space to userspace.=20


My tools find similar cloned bugs
The same bug happens in /net/netrom/af_netrom.c


static int nr_getname(struct socket *sock, struct sockaddr *uaddr,
        int peer)
{
        struct full_sockaddr_ax25 *sax =3D (struct full_sockaddr_ax25 *)uad=
dr;
        struct sock *sk =3D sock->sk;
        struct nr_sock *nr =3D nr_sk(sk);
        int uaddr_len;

        memset(&sax->fsa_ax25, 0, sizeof(struct sockaddr_ax25));

        lock_sock(sk);
        if (peer !=3D 0) {
                if (sk->sk_state !=3D TCP_ESTABLISHED) {
                        release_sock(sk);
                        return -ENOTCONN;
                }
                sax->fsa_ax25.sax25_family =3D AF_NETROM;
                sax->fsa_ax25.sax25_ndigis =3D 1;
                sax->fsa_ax25.sax25_call   =3D nr->user_addr;
                memset(sax->fsa_digipeater, 0, sizeof(sax->fsa_digipeater));
                sax->fsa_digipeater[0]     =3D nr->dest_addr;
                uaddr_len =3D sizeof(struct full_sockaddr_ax25);
        } else {
                sax->fsa_ax25.sax25_family =3D AF_NETROM;
                sax->fsa_ax25.sax25_ndigis =3D 0;
                sax->fsa_ax25.sax25_call   =3D nr->source_addr;
                uaddr_len =3D sizeof(struct sockaddr_ax25);
        }
        release_sock(sk);

        return uaddr_len;
}

full_sockaddr_ax25 is declared here:

struct full_sockaddr_ax25 {
        struct sockaddr_ax25 fsa_ax25;
        ax25_address    fsa_digipeater[AX25_MAX_DIGIS];
};

and sockaddr_ax25 is declared here:
struct sockaddr_ax25 {
        __kernel_sa_family_t sax25_family;
        ax25_address    sax25_call;
        int             sax25_ndigis;
        /* Digipeater ax25_address sets follow */
};

ax25_address is declared here:
typedef struct {
        char            ax25_call[7];   /* 6 call + SSID (shifted ascii!) */
} ax25_address;

We can see there are a few holes inside struct sockaddr_ax25. Thus, we have=
 to
explicitly set the hole to zero. Otherwise, the address will be passed to
copy_to_user and cause information leakage.

Suggested patch:
memset(maddr, 0, sizeof(full_sockaddr_ax25));


Thank you for the review. I appreciate your time.=20

Andrew Bao

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
