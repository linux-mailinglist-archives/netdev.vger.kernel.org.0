Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDB44E87D0
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 14:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiC0M7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 08:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiC0M7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 08:59:25 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C252C527C4
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 05:57:46 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id s11so10215183qtc.3
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 05:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oTyhPD6K11MeJ3ORncbe0EY8maSpB6zmS9J6Ji3e7HE=;
        b=EeI4uhXmoXUk7JJt+rvBuyuX90kDdVV4ag1KtxClLTgTnjh77AGYBO1bT5jfyV0Anl
         YjEeu0UAEkJ1ydjyt/ZGDRqT0Bh45K2fHV72ou0wLoSRdGgj+OMwZapbaimJFd1oKZe/
         ZcSKURTJ4Pl64eGR9oY9OiD6ZgQBr1KzE2LMfGATyMSe0JV1qRqZ3Dgl9H+Yz80nx5JQ
         zDGhmG4MQFgWv8HOfUvcnplU1qe6SjvVvnGnl7iroKDupI0Zy9oVdVVJ4O+6RcZ25vIH
         CjX/Jw4CAHYyRcZcNj391czujcHzKl3o9gXPzFtr5b1SSWr2skJRESuz6RHuI+sfgxjA
         N+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oTyhPD6K11MeJ3ORncbe0EY8maSpB6zmS9J6Ji3e7HE=;
        b=T9rK7eSjGxWs+kzXAfkQw6VSAd+Hsc3tBFQ0SMupCx350x0j5FLhZsI2IQ8nyi9Rz4
         f/DDxUL2UEC58S38emCZWLfhsxr0JcnABosI4klMJVVjKGMSIo9Ml6NjpNHdSlnlRLGW
         3P2qP5LK9au/sNaW15QQdDro1eFnFJDIOOdwQWUj78/O1Jq1vbZ/9glR48rm3vg0QdD2
         Il+33NOD/1rADaDYV9evtPxcVRSq+0gsYVoGqdnTEkpQoURBjMgzZOcI+PsOAmJaoPCU
         8ioWZYOV70aFNU/0iO2f8vOivhAGbLxjiHvf5KJtq3yS1ZvEPNQratYcIRlxctcaIFf3
         YXAw==
X-Gm-Message-State: AOAM533SUusX1bqBgPJqgEiVJl7LWXkrbiho8XSuOhmqI3ESORXz4T+J
        QVNu2pUqhH4s6D8SW34FCw==
X-Google-Smtp-Source: ABdhPJwHYiUFiFouVXW7kPUv1Ux7uUttuSCZxwZ+JLnztFQPUrWSejqL2ZnDSUR4hn4jHwfkVgg/aw==
X-Received: by 2002:a05:622a:1449:b0:2e1:c7d0:27b5 with SMTP id v9-20020a05622a144900b002e1c7d027b5mr17165429qtx.474.1648385865900;
        Sun, 27 Mar 2022 05:57:45 -0700 (PDT)
Received: from ssuryadesk ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id x20-20020ac85f14000000b002e1ee1c56c3sm10261150qta.76.2022.03.27.05.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 05:57:45 -0700 (PDT)
Date:   Sun, 27 Mar 2022 08:57:38 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Matching unbound sockets for VRF
Message-ID: <YkBfQqz66FxYmGVV@ssuryadesk>
References: <20220324171930.GA21272@EXT-6P2T573.localdomain>
 <7b5eb495-a3fe-843f-9020-0268fb681c72@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hlRCb35zarSC3Lrm"
Content-Disposition: inline
In-Reply-To: <7b5eb495-a3fe-843f-9020-0268fb681c72@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hlRCb35zarSC3Lrm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 25, 2022 at 08:13:55AM -0600, David Ahern wrote:
> On 3/24/22 11:19 AM, Stephen Suryaputra wrote:
> > Hello,
> > 
> > After upgrading to a kernel version that has commit 3c82a21f4320c ("net:
> > allow binding socket in a VRF when there's an unbound socket") several
> > of our applications don't work anymore. We are relying on the previous
> > behavior, i.e. when packets arrive on an l3mdev enslaved device, the
> > unbound sockets are matched.
> > 
> > I understand the use case for the commit but given that the previous
> > behavior has been there for quite some time since the VRF introduction,
> > should there be a configurable option to get the previous behavior? The
> > option could be having the default be the behavior achieved by the
> > commit.
> > 
> 
> I thought the behavior was controlled by the l3mdev sysctl knobs.

The addresses for Mike and Robert bounced. So, removing them from the
thread.

The problem is that our system uses a fallback rule to a vrf, e.g.:

1000:   from all lookup [l3mdev-table]
32765:  from all lookup local
32766:  from all lookup main
32767:  from all lookup default
32768:  from all lookup 256

to force traffic to go out of the vrf-enslaved interface. When the host
with the vrf initiates tcp connection, the received SYN+ACK fails to
find a matching socket after the commit. See the traffic dump:

08:51:28.625806 IP 10.1.1.1.48076 > 10.1.1.2.1499: Flags [S], seq 2060777757, win 64240, options [mss 1460,sackOK,TS val 3307983770 ecr 0,nop,wscale 7], length 0
08:51:28.625831 IP 10.1.1.2.1499 > 10.1.1.1.48076: Flags [S.], seq 4017990855, ack 2060777758, win 65160, options [mss 1460,sackOK,TS val 1658979570 ecr 3307983770,nop,wscale 7], length 0
08:51:28.625837 IP 10.1.1.1.48076 > 10.1.1.2.1499: Flags [R], seq 2060777758, win 0, length 0

The reproducer script is attached.

Thanks,

Stephen.

--hlRCb35zarSC3Lrm
Content-Type: application/x-sh
Content-Disposition: attachment; filename="socket.sh"
Content-Transfer-Encoding: quoted-printable

# +-------+     +-------+=0A# | h0    |     |    h1 |=0A# |    v01+-----+v1=
0    |=0A# |       |     |       |=0A# +-------+     +-------+=0A=0A# start=
=0Aip netns add h0=0Aip netns add h1=0A=0A# setup topology=0Aip link add h0=
_v01 type veth peer name h1_v10=0Aip link set h0_v01 netns h0=0Aip link set=
 h1_v10 netns h1=0A=0A# setup h0 to replicate the environment=0A# Without e=
nslaving h0_v01 to mgmt, netcat on h0 and h1 are connected=0Aip netns exec =
h0 sysctl -w net.ipv4.tcp_l3mdev_accept=3D1=0Aip netns exec h0 sysctl -w ne=
t.ipv4.udp_l3mdev_accept=3D1=0Aip netns exec h0 ip link add dev mgmt type v=
rf table 256=0Aip netns exec h0 ip link set mgmt up=0A# comment line below =
to see the working case=0Aip netns exec h0 ip link set h0_v01 vrf mgmt=0Aip=
 netns exec h0 ip rule add pref 32765 from all lookup local=0Aip netns exec=
 h0 ip rule del pref 0=0Aip netns exec h0 ip rule add pref 32768 from all l=
ookup 256=0Aip netns exec h0 ip rule show=0A=0A# addresses=0Aip netns exec =
h0 ip addr add 10.1.1.1/24 dev h0_v01=0Aip netns exec h0 ip link set h0_v01=
 up=0Aip netns exec h1 ip addr add 10.1.1.2/24 dev h1_v10=0Aip netns exec h=
1 ip link set h1_v10 up=0A=0A# run server on h1 and connect from h0=0Aip ne=
tns exec h1 nc -l 1499 > filename.out &=0ASERVER_PID=3D$!=0Aip netns exec h=
1 tcpdump -w traffic.pcap -i h1_v10 tcp &=0ATCPDUMP_PID=3D$!=0Asleep 5=0Aca=
t <<EOF > filename.in=0AConnected=0AEOF=0Aip netns exec h0 nc 10.1.1.2 1499=
 < filename.in &=0ACLIENT_PID=3D$!=0Asleep 5 =0Aecho "filename.out:"=0Acat =
filename.out=0A=0A# teardown=0Akill $CLIENT_PID=0Akill $SERVER_PID=0Arm fil=
ename.in filename.out=0Aip netns del h1=0Aip netns exec h0 ip link del h0_v=
01=0Aip netns exec h0 ip link del mgmt=0Aip netns del h0=0A=0A# show traffi=
c=0Await $TCPDUMP_PID=0Atcpdump -r traffic.pcap=0Arm traffic.pcap=0A
--hlRCb35zarSC3Lrm--
