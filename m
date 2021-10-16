Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE124305A9
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 01:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbhJPXzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 19:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbhJPXzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 19:55:51 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E4FC061765
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 16:53:41 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id j190so5515433pgd.0
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 16:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=zI4+murqGWeXA+/iHLW/xzoeA7R6WZUdZyqBRDLcSTU=;
        b=yThL4QwmYG6hDdMyqU92whNkqrOXX17Br9giKx9IhaQXBkx4kMQh8i/xmF3OGivSIE
         T0O+MXHLTHkuCaDtZVI8WwVkVGSlkaSE0KqWJxLETx1QmgNSwyyJHPRuowuQ1jKvrveB
         rhtEOHLQk4fVHQpk4j0I8SxTzOOq2Ya/0PAiS9YGqcQ/YVkQ5N/lrDD5X5IDa+4vfXnp
         by2D9h9vt2nbOq3l+fVDxsc5nF0FzdV/YEjXVpLvzFePcscFqDW2jDJj74yoviLtJ/11
         7AfCnIvzfd+oDGf+4LYb8ZJBSN4e18htVMIoI6q3BdwjEoOkSMj2qCGNHAYRKw3LGgZm
         YB6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=zI4+murqGWeXA+/iHLW/xzoeA7R6WZUdZyqBRDLcSTU=;
        b=R13eRUxYe7Yg3Q99IM+pmD2uJhzjmWngpoETaBOwGAD2gV7OZxY13u+wxPWUm6Wxjv
         GqEiaM59d47KiUZ6O95zibV4Rqk7nwkFF95f61w/du6nwEqAcbnkB2TfrJsIrswwA2gJ
         qlMEf2USZDekdbnJy4V5k431M8RBwHI0pJ9oPJ57KZWe7X+BfxsZNyt28GWYgwAs46Oy
         JRihaGW1dvcxmtcI5JjeSKi4u6JIbgqiJBj4vtOcV954vd6fHv55JdP53vXeSHC0EOdK
         2kY+O5t6bdK3Zndb2vLMBfXcKKa7YE2iOMbcWd7KHbBTPdNHGcBPdVxOMtmPWgHxmhE9
         K8vg==
X-Gm-Message-State: AOAM530qdQhJGwjojxtZgaOZxghNbigVih7gxinY2EcZMsIipPOgQOXi
        SXs3cEXOjGtso2y+EwN04A5OKw==
X-Google-Smtp-Source: ABdhPJzo+xEsGdA/yr1XsHtgSG5J5z9cw3gUCyOstmOmSd1Gt64wuw+kb7WpX7miOdRyrhWpBmNp7Q==
X-Received: by 2002:a63:6bc2:: with SMTP id g185mr11147502pgc.356.1634428420680;
        Sat, 16 Oct 2021 16:53:40 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id n202sm8663586pfd.160.2021.10.16.16.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 16:53:40 -0700 (PDT)
Date:   Sat, 16 Oct 2021 16:53:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 214739] New: Information leakage from kernel to user space
 in /net/qrtr/qrtr.c
Message-ID: <20211016165337.18a1299e@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sat, 16 Oct 2021 20:16:08 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214739] New: Information leakage from kernel to user space in=
 /net/qrtr/qrtr.c


https://bugzilla.kernel.org/show_bug.cgi?id=3D214739

            Bug ID: 214739
           Summary: Information leakage from kernel to user space in
                    /net/qrtr/qrtr.c
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15-rc5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
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
The same bug happens in /net/qtr/qrtr.c

static int qrtr_getname(struct socket *sock, struct sockaddr *saddr,
                        int peer)
{
        struct qrtr_sock *ipc =3D qrtr_sk(sock->sk);
        struct sockaddr_qrtr qaddr;
        struct sock *sk =3D sock->sk;

        lock_sock(sk);
        if (peer) {
                if (sk->sk_state !=3D TCP_ESTABLISHED) {
                        release_sock(sk);
                        return -ENOTCONN;
                }

                qaddr =3D ipc->peer;
        } else {
                qaddr =3D ipc->us;
        }
        release_sock(sk);

        qaddr.sq_family =3D AF_QIPCRTR;

        memcpy(saddr, &qaddr, sizeof(qaddr));

        return sizeof(qaddr);
}



sockaddr_qrtr is declared here:

struct sockaddr_qrtr {
        __kernel_sa_family_t sq_family;
        __u32 sq_node;
        __u32 sq_port;
};

We can see there is a hole between sq_family and sq_node. Thus, we have to
explicitly set the hole to zero. Otherwise, the address will be passed to
copy_to_user and cause information leakage.

Suggested patch:
memset(maddr, 0, sizeof(sockaddr_qrtr));


Thank you for the review. I appreciate your time.=20

Andrew Bao

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
