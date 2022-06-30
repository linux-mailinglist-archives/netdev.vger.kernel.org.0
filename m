Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34B2561842
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiF3Kh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbiF3KhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:37:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F94E4F1B7;
        Thu, 30 Jun 2022 03:37:21 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UAH0op016910;
        Thu, 30 Jun 2022 10:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : message-id :
 content-type : mime-version : subject : date : in-reply-to : cc : to :
 references; s=pp1; bh=WP9pcgrEunNO+xsdJ/XG7r0OlIRfBVOvJrRgO5orWwM=;
 b=mokyvrXcS3wnZFA119Mzrf8lqfHAJbuQVcUYUc/Z1FXt3yva+g4xe2evazvY1nxpfnPr
 0i5MkiMnlPicNPL7/JjgDErBj5dxpIVcg+gB7DLa4WQM/Kdc4ZLaq6lTjOzAtioasjWp
 GSfFyBwVXj8Yv8HcThSMWHYVWo8QxrFeLQHp1kC4tNjVmfpoUwB/IJVPRtmEculLE9X8
 H8yofMU91sT8f5RpNGV5JVYCdUELzrWZ+lS64uUZ2Dyom4DbxbELJwuH21NWm73LokuR
 rxxr8zpIOnDsNM3Q/akR54Y7OidN1P7b8HE6bCeV3/sdjh9ZBgw/IEInXNsYedlcBnaw fg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h19xn0dy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 10:37:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UALK8g028751;
        Thu, 30 Jun 2022 10:37:12 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj7yf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 10:37:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UAb9w39634192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 10:37:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FBDE11C07A;
        Thu, 30 Jun 2022 10:37:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E755111C07B;
        Thu, 30 Jun 2022 10:37:07 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.109.240.215])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 10:37:07 +0000 (GMT)
From:   Sachin Sant <sachinp@linux.ibm.com>
Message-Id: <DC7D445E-8A04-4104-AF90-6A530CB5FF93@linux.ibm.com>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_D77BF1E8-7974-4C36-9898-319F4CE0CFF3"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [powerpc] Fingerprint systemd service fails to start
 (next-20220624)
Date:   Thu, 30 Jun 2022 16:07:06 +0530
In-Reply-To: <20220629174729.6744-1-kuniyu@amazon.com>
Cc:     davem@davemloft.net, linux-next@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
References: <FAA64E21-B3FE-442A-BA6B-D865006CBE3E@linux.ibm.com>
 <20220629174729.6744-1-kuniyu@amazon.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: s5YjJ9wUcGeHDp4KqWkosCGRZPA70Tko
X-Proofpoint-ORIG-GUID: s5YjJ9wUcGeHDp4KqWkosCGRZPA70Tko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206300040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_D77BF1E8-7974-4C36-9898-319F4CE0CFF3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

>>>=20
>> Yes, the problem can be recreated after login. I have collected the =
strace
>> logs.
>=20
> I confirmed fprintd failed to launch with this message on failure =
case.
>=20
> =3D=3D=3D
> ltcden8-lp6 fprintd[2516]: (fprintd:2516): fprintd-WARNING **: =
01:56:45.705: Failed to open connection to bus: Could not connect: =
Connection refused
> =3D=3D=3D
>=20
>=20
> But in the strace log of both cases, only one socket is created and
> following connect() completes without an error.  And the peer socket
> does not seem to be d-bus one.
>=20
> =3D=3D=3D
> $ cat working-case/strace-fprintd-service.log | grep "socket("
> 01:52:08 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D =
3
> $ cat working-case/strace-fprintd-service.log | grep "socket(" -A 10
> 01:52:08 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D =
3
> ...
> 01:52:08 connect(3, {sa_family=3DAF_UNIX, =
sun_path=3D"/run/systemd/private"}, 22) =3D 0
> ...
> $ cat not-working-case/strace-fprintd-service.log | grep "socket("
> 01:58:14 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D =
3
> $ cat not-working-case/strace-fprintd-service.log | grep "socket(" -A =
10
> 01:58:14 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D =
3
> ...
> 01:58:14 connect(3, {sa_family=3DAF_UNIX, =
sun_path=3D"/run/systemd/private"}, 22) =3D 0
> =3D=3D=3D
>=20
> So I think the error message part is not traced well.
> Could you try to strace directly for the command in ExecStart section =
of
> its unit file?
>=20

Thank you for your inputs. This is what I did, changed the ExecStart
line in /usr/lib/systemd/system/fprintd.service to

ExecStart=3Dstrace -t -ff /usr/libexec/fprintd

Captured the logs after recreating the problem.
fprintd-pass-strace.log (working case) and
fprintd-strace-fail.log (failing case).

In case of failure I see following:

Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 =
connect(5, {sa_family=3DAF_UNIX, =
sun_path=3D"/var/run/dbus/system_bus_socket"}, 110) =3D -1 ECONNREFUSED =
(Connection refused)
fprintd-fail-strace.log:Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  =
5599] 05:52:41 sendmsg(5, {msg_name=3D{sa_family=3DAF_UNIX, =
sun_path=3D"/run/systemd/journal/socket"}, msg_namelen=3D29, =
msg_iov=3D[{iov_base=3D"GLIB_OLD_LOG_API", iov_len=3D16}, {iov_base=3D"=3D=
", iov_len=3D1}, {iov_base=3D"1", iov_len=3D1}, {iov_base=3D"\n", =
iov_len=3D1}, {iov_base=3D"MESSAGE", iov_len=3D7}, {iov_base=3D"=3D", =
iov_len=3D1}, {iov_base=3D"Failed to open connection to bus"..., =
iov_len=3D71}, {iov_base=3D"\n", iov_len=3D1}, {iov_base=3D"PRIORITY", =
iov_len=3D8}, {iov_base=3D"=3D", iov_len=3D1}, {iov_base=3D"4", =
iov_len=3D1}, {iov_base=3D"\n", iov_len=3D1}, {iov_base=3D"GLIB_DOMAIN", =
iov_len=3D11}, {iov_base=3D"=3D", iov_len=3D1}, {iov_base=3D"fprintd", =
iov_len=3D7}, {iov_base=3D"\n", iov_len=3D1}], msg_iovlen=3D16, =
msg_controllen=3D0, msg_flags=3D0}, MSG_NOSIGNAL) =3D -1 ECONNREFUSED =
(Connection refused)

For working case connect works

fprintd-pass-strace.log:Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  =
2658] 05:58:18 connect(5, {sa_family=3DAF_UNIX, =
sun_path=3D"/var/run/dbus/system_bus_socket"}, 110) =3D 0


- Sachin


--Apple-Mail=_D77BF1E8-7974-4C36-9898-319F4CE0CFF3
Content-Disposition: attachment;
	filename=fprintd-fail-strace.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="fprintd-fail-strace.log"
Content-Transfer-Encoding: 7bit

Jun 30 05:52:41 ltcden8-lp6 dbus-daemon[1043]: [system] Activating via systemd: service name='net.reactivated.Fprint' unit='fprintd.service' requested by ':1.47' (uid=0 pid=5434 comm="/bin/login -p --      ")
Jun 30 05:52:41 ltcden8-lp6 systemd[1]: Starting Fingerprint Authentication Daemon...
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 execve("/usr/libexec/fprintd", ["/usr/libexec/fprintd", "2>>/home/fprintd.log"], 0x7fffe5fe1958 /* 4 vars */) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 brk(NULL)                      = 0x135290000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0644, st_size=51423, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 51423, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fffb00d0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libglib-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200\254\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1532208, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 1577192, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffaff40000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffb00a0000, 65536, PROT_NONE) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffb00b0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x160000) = 0x7fffb00b0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgio-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`b\3\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=2462784, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 2498944, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffafc00000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffafe50000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x240000) = 0x7fffafe50000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgobject-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\254\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=471336, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 528792, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffafeb0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffaff20000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x60000) = 0x7fffaff20000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgmodule-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\17\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=69104, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131184, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffafe80000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffafe90000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffafe90000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libfprint-2.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\364\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=734504, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 49733680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffacc00000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffacca0000, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x90000) = 0x7fffacca0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffaccd0000, 48881712, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffaccd0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libpolkit-gobject-1.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240k\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=201232, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 262520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffafbb0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffafbe0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffafbe0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffafbf0000, 376, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffafbf0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 ,\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=135848, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 197304, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffafb70000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffafb90000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffafb90000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/libpthread-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300z\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=237688, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 279840, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffacbb0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffacbe0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffacbe0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/libc-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\240\2\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=2286024, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 2118216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac800000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac9f0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e0000) = 0x7fffac9f0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgnutls.so.30", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\340r\3\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=2454872, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 2504056, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac400000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac640000, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x230000) = 0x7fffac640000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libpcre.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\340\24\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=529528, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 589960, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffacb10000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffacb90000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x70000) = 0x7fffacb90000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libffi.so.6", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200\25\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=69432, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 132216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffacae0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffacaf0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffacaf0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\340\16\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=73392, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131336, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffacab0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffacac0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffacac0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffacad0000, 264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffacad0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\"\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=136000, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 196624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffaca70000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffaca90000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffaca90000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300e\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=270416, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 337280, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffaca10000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffaca50000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffaca50000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libresolv.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 5\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=137440, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 207344, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac7c0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac7e0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffac7e0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libmount.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\271\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=534816, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 595184, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac720000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac7a0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x70000) = 0x7fffac7a0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgusb.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`A\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=136600, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 196800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac6e0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac700000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffac700000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac710000, 192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffac710000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libpixman-1.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\203\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=599720, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 655432, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac350000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac3e0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x80000) = 0x7fffac3e0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/libm-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\327\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1133968, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 1179936, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac220000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac330000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x100000) = 0x7fffac330000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libnss3.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\317\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1668952, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 1713320, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac070000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac1f0000, 65536, PROT_NONE) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac200000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7fffac200000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libsystemd.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200g\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1802408, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 1841288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffabea0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac050000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1a0000) = 0x7fffac050000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libp11-kit.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \233\2\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1705720, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 1743800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffabcf0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffabe70000, 65536, PROT_NONE) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffabe80000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7fffabe80000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libidn2.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\24\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=170400, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 196624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac6a0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac6c0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffac6c0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac6d0000, 16, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffac6d0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libunistring.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \r\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1806488, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 1706128, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffabb40000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffabcd0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7fffabcd0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libtasn1.so.6", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`)\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=138232, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 197152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffabb00000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffabb20000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffabb20000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libnettle.so.6", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\224\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=333040, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 393304, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffaba90000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffabae0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x40000) = 0x7fffabae0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libhogweed.so.4", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`p\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=266416, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 327688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffaba30000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffaba70000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffaba70000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffaba80000, 8, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffaba80000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgmp.so.10", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\272\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1406600, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 655488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab980000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffaba10000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x80000) = 0x7fffaba10000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libpcre2-8.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\36\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=595752, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 655792, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab8d0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab960000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x80000) = 0x7fffab960000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200\240\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=470120, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 530168, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab840000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab8b0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x60000) = 0x7fffab8b0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`\24\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=69456, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffac670000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac680000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffac680000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffac690000, 24, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffac690000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/librt-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\32\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=81152, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab810000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab820000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffab820000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libusb-1.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0?\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=201680, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 262472, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab7c0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab7e0000, 65536, PROT_NONE) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab7f0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffab7f0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libnssutil3.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`\304\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=267888, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 329408, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab760000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab7a0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffab7a0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libplc4.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\22\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=69464, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131184, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab730000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab740000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffab740000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libplds4.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\r\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=69328, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131200, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab700000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab710000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffab710000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libnspr4.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\267\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=340448, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 406096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab690000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab6e0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x40000) = 0x7fffab6e0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`+\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=295392, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 327688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab630000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab670000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffab670000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab680000, 8, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffab680000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/liblz4.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\37\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=200816, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 262152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab5e0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab610000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffab610000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab620000, 8, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffab620000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libcap.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \37\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=70032, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131448, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab5b0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab5c0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffab5c0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgcrypt.so.20", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\256\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=1147096, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 1198320, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab480000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab590000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x100000) = 0x7fffab590000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libudev.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \275\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=873008, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fffab460000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 920920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab370000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab440000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc0000) = 0x7fffab440000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/lib64/libgpg-error.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240;\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0755, st_size=209000, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 262648, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffab320000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(0x7fffab350000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffab350000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac9f0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab350000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffafb90000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffacbe0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab960000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffacac0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffaca50000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac680000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab8b0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab820000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac7a0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab440000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab590000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab5c0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab610000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab670000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab6e0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab710000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab740000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab7a0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffab7f0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffaba10000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffabae0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffaba70000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffabb20000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffabcd0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac6c0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffacaf0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffabe80000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac050000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac200000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac330000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac3e0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac640000, 131072, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffacb90000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffb00b0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffaff20000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffafe90000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffaca90000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac7e0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffafe50000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffac700000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffafbe0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffacca0000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x11f740000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fffb0150000, 65536, PROT_READ) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 munmap(0x7fffb00d0000, 51423)  = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 set_tid_address(0x7fffab464330) = 5599
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 set_robust_list(0x7fffab464340, 24) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 rt_sigaction(SIGRTMIN, {sa_handler=0x7fffacbb7370, sa_mask=[], sa_flags=SA_SIGINFO}, NULL, 8) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 rt_sigaction(SIGRT_1, {sa_handler=0x7fffacbb7480, sa_mask=[], sa_flags=SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 brk(NULL)                      = 0x135290000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 brk(0x1352c0000)               = 0x1352c0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 statfs("/sys/fs/selinux", 0x7fffea162540) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 statfs("/selinux", 0x7fffea162540) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/proc/filesystems", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "nodev\tsysfs\nnodev\ttmpfs\nnodev\tbd"..., 1024) = 333
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "", 1024)              = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 access("/etc/selinux/config", F_OK) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 access("/etc/system-fips", F_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 access("/etc/gcrypt/fips_enabled", F_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/proc/sys/crypto/fips_enabled", O_RDONLY) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "0\n", 1024)           = 2
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 prctl(PR_CAPBSET_READ, CAP_MAC_OVERRIDE) = 1
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 prctl(PR_CAPBSET_READ, 0x30 /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 prctl(PR_CAPBSET_READ, CAP_CHECKPOINT_RESTORE) = 1
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 prctl(PR_CAPBSET_READ, 0x2c /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 prctl(PR_CAPBSET_READ, 0x2a /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 prctl(PR_CAPBSET_READ, 0x29 /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/proc/self/auxv", O_RDONLY) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\26\0\0\0\0\0\0\0\26\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\26\0\0\0\0\0\0\0\26\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\23\0\0\0\0\0\0\0\200\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\24\0\0\0\0\0\0\0\200\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "!\0\0\0\0\0\0\0\0\0\20\260\377\177\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "(\0\0\0\0\0\0\0\0\300\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, ")\0\0\0\0\0\0\0\200\0\6\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "*\0\0\0\0\0\0\0\0\200\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "+\0\0\0\0\0\0\0\200\0\10\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, ",\0\0\0\0\0\0\0\0\0\20\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "-\0\0\0\0\0\0\0\200\0\10\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, ".\0\0\0\0\0\0\0\0\0@\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "/\0\0\0\0\0\0\0\200\0\20\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "3\0\0\0\0\0\0\0\200\20\0\0\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "\20\0\0\0\0\0\0\0\302e\0\334\0\0\0\0", 16) = 16
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/proc/sys/crypto/fips_enabled", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "0\n", 1024)           = 2
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 access("/etc/system-fips", F_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 getrandom("\xc1", 1, GRND_NONBLOCK) = 1
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 stat("/etc/crypto-policies/back-ends/gnutls.config", {st_mode=S_IFREG|0644, st_size=437, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/etc/crypto-policies/back-ends/gnutls.config", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0644, st_size=437, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "SYSTEM=NONE:+MAC-ALL:-MD5:+GROUP"..., 8192) = 437
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 read(3, "", 8192)              = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 brk(0x1352f0000)               = 0x1352f0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 fstat(3, {st_mode=S_IFREG|0644, st_size=217800224, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 217800224, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fff9e200000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 close(3)                       = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 rt_sigprocmask(SIG_SETMASK, ~[RTMIN RT_1], [], 8) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK) = 3
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 write(3, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mmap(NULL, 8454144, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x7fff9d9f0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 mprotect(0x7fff9da00000, 8388608, PROT_READ|PROT_WRITE) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 clone(child_stack=0x7fff9e1fe410, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID/usr/bin/strace: Process 5600 attached
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: , parent_tid=[5600], tls=0x7fff9e2062e0, child_tidptr=0x7fff9e1fec40) = 5600
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 set_robust_list(0x7fff9e1fec50, 24 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... set_robust_list resumed>) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 <... rt_sigprocmask resumed>NULL, 8) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... mmap resumed>) = 0x7fff959f0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 <... futex resumed>) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 munmap(0x7fff959f0000, 39911424 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... munmap resumed>) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 munmap(0x7fff9c000000, 27197440 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... munmap resumed>) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 <... futex resumed>) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 mprotect(0x7fff98000000, 196608, PROT_READ|PROT_WRITE <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... mprotect resumed>) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 <... openat resumed>) = 4
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 prctl(PR_SET_NAME, "gmain" <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 fstat(4,  <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... prctl resumed>) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 <... fstat resumed>{st_mode=S_IFREG|0644, st_size=2997, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 poll([{fd=3, events=POLLIN}], 1, -1 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 read(4,  <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... poll resumed>) = 1 ([{fd=3, revents=POLLIN}])
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 <... read resumed>"# Locale name alias data base.\n#"..., 8192) = 2997
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 read(3,  <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 read(4,  <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... read resumed>"\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 <... read resumed>"", 8192) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 poll([{fd=3, events=POLLIN}], 1, -1 <unfinished ...>
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 close(4)           = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US.UTF-8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US.utf8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US.UTF-8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US.utf8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 brk(NULL)          = 0x1352f0000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 brk(0x135320000)   = 0x135320000
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 rt_sigaction(SIGPIPE, {sa_handler=SIG_IGN, sa_mask=[PIPE], sa_flags=SA_RESTART}, {sa_handler=SIG_IGN, sa_mask=[], sa_flags=0}, 8) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK) = 4
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 write(4, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC, 0) = 5
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 fcntl(5, F_GETFL)  = 0x2 (flags O_RDWR)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 fcntl(5, F_SETFL, O_RDWR|O_NONBLOCK) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 connect(5, {sa_family=AF_UNIX, sun_path="/var/run/dbus/system_bus_socket"}, 110) = -1 ECONNREFUSED (Connection refused)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/usr/lib64/charset.alias", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 close(5)           = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 getpeername(2, {sa_family=AF_UNIX, sun_path="/run/systemd/journal/stdout"}, [128 => 30]) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 futex(0x7fffb00c0ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 socket(AF_UNIX, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 5
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 sendmsg(5, {msg_name={sa_family=AF_UNIX, sun_path="/run/systemd/journal/socket"}, msg_namelen=29, msg_iov=[{iov_base="GLIB_OLD_LOG_API", iov_len=16}, {iov_base="=", iov_len=1}, {iov_base="1", iov_len=1}, {iov_base="\n", iov_len=1}, {iov_base="MESSAGE", iov_len=7}, {iov_base="=", iov_len=1}, {iov_base="Failed to open connection to bus"..., iov_len=71}, {iov_base="\n", iov_len=1}, {iov_base="PRIORITY", iov_len=8}, {iov_base="=", iov_len=1}, {iov_base="4", iov_len=1}, {iov_base="\n", iov_len=1}, {iov_base="GLIB_DOMAIN", iov_len=11}, {iov_base="=", iov_len=1}, {iov_base="fprintd", iov_len=7}, {iov_base="\n", iov_len=1}], msg_iovlen=16, msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 ECONNREFUSED (Connection refused)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 ioctl(2, TCGETS, 0x7fffea161f0c) = -1 ENOTTY (Inappropriate ioctl for device)
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 getpid()           = 5599
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) = 6
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 fstat(6, {st_mode=S_IFREG|0644, st_size=3545, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 fstat(6, {st_mode=S_IFREG|0644, st_size=3545, ...}) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 read(6, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\5\0\0\0\5\0\0\0\0"..., 8192) = 3545
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 _llseek(6, -2261, [1284], SEEK_CUR) = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 read(6, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\5\0\0\0\5\0\0\0\0"..., 8192) = 2261
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 close(6)           = 0
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 write(2, "\n(fprintd:5599): fprintd-WARNING"..., 123
Jun 30 05:52:41 ltcden8-lp6 strace[5599]: [pid  5599] 05:52:41 write(2, "\n(fprintd:5599): fprintd-WARNING"..., 123
Jun 30 05:52:41 ltcden8-lp6 strace[5599]: (fprintd:5599): fprintd-WARNING **: 05:52:41.330:
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: (fprintd[pid  5599] 05:52:41 exit_group(1)      = ?
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 <... poll resumed> <unfinished ...>) = ?
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5600] 05:52:41 +++ exited with 1 +++
Jun 30 05:52:41 ltcden8-lp6 strace[5595]: 05:52:41 +++ exited with 1 +++
Jun 30 05:52:41 ltcden8-lp6 systemd[1]: fprintd.service: Main process exited, code=exited, status=1/FAILURE
Jun 30 05:52:41 ltcden8-lp6 systemd[1]: fprintd.service: Failed with result 'exit-code'.
Jun 30 05:52:41 ltcden8-lp6 systemd[1]: Failed to start Fingerprint Authentication Daemon.
Jun 30 05:53:06 ltcden8-lp6 dbus-daemon[1043]: [system] Failed to activate service 'net.reactivated.Fprint': timed out (service_start_timeout=25000ms)

--Apple-Mail=_D77BF1E8-7974-4C36-9898-319F4CE0CFF3
Content-Disposition: attachment;
	filename=fprintd-pass-strace.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="fprintd-pass-strace.log"
Content-Transfer-Encoding: 7bit

Jun 30 05:58:18 ltcden8-lp6 dbus-daemon[1038]: [system] Activating via systemd: service name='net.reactivated.Fprint' unit='fprintd.service' requested by ':1.26' (uid=0 pid=1513 comm="/bin/login -p --      ")
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: Starting Check and migrate non-primary pmie farm instances...
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: Starting Check PMIE instances are running...
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: Starting Fingerprint Authentication Daemon...
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: Started Check and migrate non-primary pmie farm instances.
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: Started Check PMIE instances are running.
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 execve("/usr/libexec/fprintd", ["/usr/libexec/fprintd"], 0x7fffdbc12bf0 /* 4 vars */) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 brk(NULL)                      = 0x120930000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0644, st_size=51423, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 51423, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fffb7420000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libglib-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200\254\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1532208, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 1577192, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb7290000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb73f0000, 65536, PROT_NONE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb7400000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x160000) = 0x7fffb7400000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgio-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`b\3\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=2462784, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 2498944, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb7000000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb7250000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x240000) = 0x7fffb7250000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgobject-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\254\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=471336, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 528792, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb6f70000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6fe0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x60000) = 0x7fffb6fe0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgmodule-2.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\17\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=69104, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131184, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb6f40000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6f50000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb6f50000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libfprint-2.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\364\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=734504, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 49733680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3e00000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3ea0000, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x90000) = 0x7fffb3ea0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3ed0000, 48881712, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb3ed0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libpolkit-gobject-1.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240k\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=201232, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 262520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb6ef0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6f20000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffb6f20000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6f30000, 376, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb6f30000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 ,\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=135848, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 197304, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb6eb0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6ed0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffb6ed0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/libpthread-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300z\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=237688, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 279840, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb6e60000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6e90000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffb6e90000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/libc-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\240\2\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=2286024, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 2118216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3a00000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3bf0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e0000) = 0x7fffb3bf0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgnutls.so.30", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\340r\3\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=2454872, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 2504056, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3600000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3840000, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x230000) = 0x7fffb3840000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libpcre.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\340\24\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=529528, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 589960, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb6dc0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6e40000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x70000) = 0x7fffb6e40000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libffi.so.6", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200\25\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=69432, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 132216, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb6d90000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb6da0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb6da0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\340\16\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=73392, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131336, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3dd0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3de0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb3de0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3df0000, 264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb3df0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\"\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=136000, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 196624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3d90000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3db0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffb3db0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300e\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=270416, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 337280, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3d30000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3d70000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffb3d70000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libresolv.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 5\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=137440, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 207344, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3cf0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3d10000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffb3d10000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libmount.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\271\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=534816, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 595184, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3c50000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3cd0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x70000) = 0x7fffb3cd0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgusb.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`A\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=136600, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 196800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3c10000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3c30000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffb3c30000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3c40000, 192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb3c40000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libpixman-1.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\203\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=599720, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 655432, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3950000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb39e0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x80000) = 0x7fffb39e0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/libm-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\327\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1133968, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 1179936, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb34d0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb35e0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x100000) = 0x7fffb35e0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libnss3.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\317\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1668952, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 1713320, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3320000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb34a0000, 65536, PROT_NONE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb34b0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7fffb34b0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libsystemd.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200g\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1802408, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 1841288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3150000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3300000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1a0000) = 0x7fffb3300000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libp11-kit.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \233\2\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1705720, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 1743800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2fa0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3120000, 65536, PROT_NONE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3130000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7fffb3130000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libidn2.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\24\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=170400, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 196624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3910000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3930000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffb3930000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb3940000, 16, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb3940000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libunistring.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \r\1\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1806488, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 1706128, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2df0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2f80000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x180000) = 0x7fffb2f80000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libtasn1.so.6", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`)\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=138232, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 197152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb38d0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb38f0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7fffb38f0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libnettle.so.6", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\224\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=333040, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 393304, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2d80000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2dd0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x40000) = 0x7fffb2dd0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libhogweed.so.4", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`p\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=266416, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 327688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb3870000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb38b0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffb38b0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb38c0000, 8, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb38c0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgmp.so.10", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\272\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1406600, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 655488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2cd0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2d60000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x80000) = 0x7fffb2d60000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libpcre2-8.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\36\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=595752, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 655792, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2c20000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2cb0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x80000) = 0x7fffb2cb0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\200\240\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=470120, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 530168, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2b90000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2c00000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x60000) = 0x7fffb2c00000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`\24\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=69456, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2b60000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2b70000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb2b70000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2b80000, 24, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb2b80000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/glibc-hwcaps/power9/librt-2.28.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\32\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=81152, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2b30000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2b40000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb2b40000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libusb-1.0.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0?\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=201680, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 262472, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2ae0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2b00000, 65536, PROT_NONE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2b10000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffb2b10000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libnssutil3.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`\304\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=267888, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 329408, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2a80000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2ac0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffb2ac0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libplc4.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\22\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=69464, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131184, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2a50000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2a60000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb2a60000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libplds4.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\300\r\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=69328, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131200, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2a20000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2a30000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb2a30000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libnspr4.so", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240\267\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=340448, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 406096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb29b0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2a00000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x40000) = 0x7fffb2a00000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0`+\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=295392, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 327688, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2950000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2990000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x30000) = 0x7fffb2990000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb29a0000, 8, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb29a0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/liblz4.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\0\37\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=200816, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 262152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2900000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2930000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffb2930000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2940000, 8, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fffb2940000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libcap.so.2", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \37\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=70032, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131448, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb28d0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb28e0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0x7fffb28e0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgcrypt.so.20", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0@\256\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=1147096, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 1198320, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb27a0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb28b0000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x100000) = 0x7fffb28b0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libudev.so.1", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0 \275\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=873008, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fffb7270000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 920920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb26b0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2780000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc0000) = 0x7fffb2780000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/lib64/libgpg-error.so.0", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\25\0\1\0\0\0\240;\0\0\0\0\0\0"..., 832) = 832
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0755, st_size=209000, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 262648, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fffb2660000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(0x7fffb2690000, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fffb2690000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3bf0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2690000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb6ed0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb6e90000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2cb0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3de0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3d70000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2b70000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2c00000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2b40000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3cd0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2780000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb28b0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb28e0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2930000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2990000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2a00000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2a30000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2a60000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2ac0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2b10000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2d60000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2dd0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb38b0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb38f0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb2f80000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3930000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb6da0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3130000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3300000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb34b0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb35e0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb39e0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3840000, 131072, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb6e40000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb7400000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb6fe0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb6f50000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3db0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3d10000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb7250000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3c30000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb6f20000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb3ea0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x10cc80000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffb74a0000, 65536, PROT_READ) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 munmap(0x7fffb7420000, 51423)  = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 set_tid_address(0x7fffb7274330) = 2658
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 set_robust_list(0x7fffb7274340, 24) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 rt_sigaction(SIGRTMIN, {sa_handler=0x7fffb6e67370, sa_mask=[], sa_flags=SA_SIGINFO}, NULL, 8) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 rt_sigaction(SIGRT_1, {sa_handler=0x7fffb6e67480, sa_mask=[], sa_flags=SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 brk(NULL)                      = 0x120930000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 brk(0x120960000)               = 0x120960000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 statfs("/sys/fs/selinux", 0x7fffcb0b5410) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 statfs("/selinux", 0x7fffcb0b5410) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/proc/filesystems", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "nodev\tsysfs\nnodev\ttmpfs\nnodev\tbd"..., 1024) = 333
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "", 1024)              = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 access("/etc/selinux/config", F_OK) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 access("/etc/system-fips", F_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 access("/etc/gcrypt/fips_enabled", F_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/proc/sys/crypto/fips_enabled", O_RDONLY) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "0\n", 1024)           = 2
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 prctl(PR_CAPBSET_READ, CAP_MAC_OVERRIDE) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 prctl(PR_CAPBSET_READ, 0x30 /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 prctl(PR_CAPBSET_READ, CAP_CHECKPOINT_RESTORE) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 prctl(PR_CAPBSET_READ, 0x2c /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 prctl(PR_CAPBSET_READ, 0x2a /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 prctl(PR_CAPBSET_READ, 0x29 /* CAP_??? */) = -1 EINVAL (Invalid argument)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/proc/self/auxv", O_RDONLY) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\26\0\0\0\0\0\0\0\26\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\26\0\0\0\0\0\0\0\26\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\23\0\0\0\0\0\0\0\200\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\24\0\0\0\0\0\0\0\200\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "!\0\0\0\0\0\0\0\0\0E\267\377\177\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "(\0\0\0\0\0\0\0\0\300\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, ")\0\0\0\0\0\0\0\200\0\6\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "*\0\0\0\0\0\0\0\0\200\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "+\0\0\0\0\0\0\0\200\0\10\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, ",\0\0\0\0\0\0\0\0\0\20\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "-\0\0\0\0\0\0\0\200\0\10\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, ".\0\0\0\0\0\0\0\0\0@\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "/\0\0\0\0\0\0\0\200\0\20\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "3\0\0\0\0\0\0\0\200\20\0\0\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "\20\0\0\0\0\0\0\0\302e\0\334\0\0\0\0", 16) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/proc/sys/crypto/fips_enabled", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "0\n", 1024)           = 2
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 access("/etc/system-fips", F_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 getrandom("\x12", 1, GRND_NONBLOCK) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 stat("/etc/crypto-policies/back-ends/gnutls.config", {st_mode=S_IFREG|0644, st_size=437, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/etc/crypto-policies/back-ends/gnutls.config", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0644, st_size=437, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "SYSTEM=NONE:+MAC-ALL:-MD5:+GROUP"..., 8192) = 437
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 read(3, "", 8192)              = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 brk(0x120990000)               = 0x120990000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 fstat(3, {st_mode=S_IFREG|0644, st_size=217800224, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 217800224, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fffa5600000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 close(3)                       = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 rt_sigprocmask(SIG_SETMASK, ~[RTMIN RT_1], [], 8) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK) = 3
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 write(3, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mmap(NULL, 8454144, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x7fffa4df0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 mprotect(0x7fffa4e00000, 8388608, PROT_READ|PROT_WRITE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: 05:58:18 clone(child_stack=0x7fffa55fe410, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID/usr/bin/strace: Process 2696 attached
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: , parent_tid=[2696], tls=0x7fffa56062e0, child_tidptr=0x7fffa55fec40) = 2696
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 set_robust_list(0x7fffa55fec50, 24 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... set_robust_list resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... rt_sigprocmask resumed>NULL, 8) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... mmap resumed>) = 0x7fff9cdf0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 munmap(0x7fff9cdf0000, 52494336 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... munmap resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 munmap(0x7fffa4000000, 14614528 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... munmap resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 mprotect(0x7fffa0000000, 196608, PROT_READ|PROT_WRITE <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... mprotect resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... openat resumed>) = 4
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(4,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 prctl(PR_SET_NAME, "gmain" <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... fstat resumed>{st_mode=S_IFREG|0644, st_size=2997, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... prctl resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(4,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 poll([{fd=3, events=POLLIN}], 1, -1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... read resumed>"# Locale name alias data base.\n#"..., 8192) = 2997
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... poll resumed>) = 1 ([{fd=3, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(4,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 read(3,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... read resumed>"", 8192) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 <... read resumed>"\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(4 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:18 poll([{fd=3, events=POLLIN}], 1, -1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... close resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en_US.UTF-8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en_US.utf8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en_US/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/fprintd.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en_US.UTF-8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en_US.utf8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en_US/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/glib20.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x120990000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(0x1209c0000)   = 0x1209c0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 rt_sigaction(SIGPIPE, {sa_handler=SIG_IGN, sa_mask=[PIPE], sa_flags=SA_RESTART}, {sa_handler=SIG_IGN, sa_mask=[], sa_flags=0}, 8) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK) = 4
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(4, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC, 0) = 5
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(5, F_GETFL)  = 0x2 (flags O_RDWR)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(5, F_SETFL, O_RDWR|O_NONBLOCK) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 connect(5, {sa_family=AF_UNIX, sun_path="/var/run/dbus/system_bus_socket"}, 110) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getpid()           = 2658
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 geteuid()          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getegid()          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getpid()           = 2658
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 geteuid()          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getegid()          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 sendmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\0", iov_len=1}], msg_iovlen=1, msg_control=[{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, cmsg_data={pid=2658, uid=0, gid=0}}], msg_controllen=32, msg_flags=0}, MSG_NOSIGNAL) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 send(5, "AUTH\r\n", 6, MSG_NOSIGNAL) = 6
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 recv(5, "REJECTED EXTERNAL\r\n", 4096, 0) = 19
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 send(5, "AUTH EXTERNAL 30\r\n", 18, MSG_NOSIGNAL) = 18
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 recv(5, "OK bb5a375fa04cebcb3d24600662bd7"..., 4096, 0) = 37
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 send(5, "NEGOTIATE_UNIX_FD\r\n", 19, MSG_NOSIGNAL) = 19
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 recv(5, "AGREE_UNIX_FD\r\n", 4096, 0) = 15
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 send(5, "BEGIN\r\n", 7, MSG_NOSIGNAL) = 7
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK) = 6
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 mmap(NULL, 8454144, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x7fffa45e0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 mprotect(0x7fffa45f0000, 8388608, PROT_READ|PROT_WRITE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 clone(child_stack=0x7fffa4dee410, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID/usr/bin/strace: Process 2716 attached
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: , parent_tid=[2716], tls=0x7fffa4df62e0, child_tidptr=0x7fffa4deec40) = 2716
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 set_robust_list(0x7fffa4deec50, 24 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... set_robust_list resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 prctl(PR_SET_NAME, "gdbus" <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... prctl resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... mmap resumed>) = 0x7fff98000000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... eventfd2 resumed>) = 7
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 munmap(0x7fff9c000000, 67108864 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(7, "\1\0\0\0\0\0\0\0", 8 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... munmap resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... write resumed>) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 mprotect(0x7fff98000000, 196608, PROT_READ|PROT_WRITE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... write resumed>) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 futex(0x120997cf0, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x120997cf0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... futex resumed>) = -1 EAGAIN (Resource temporarily unavailable)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x120997cf0, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... read resumed>"\2\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 futex(0x120997cf0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... futex resumed>) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x120997cf0, FUTEX_WAKE_PRIVATE, 1) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 poll([{fd=7, events=POLLIN}], 1, 25000 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... poll resumed>) = 1 ([{fd=7, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(7, "\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 poll([{fd=7, events=POLLIN}], 1, 25000 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... write resumed>) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 sendmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\1\0\1\0\0\0\0\1\0\0\0m\0\0\0\1\1o\0\25\0\0\0/org/fre"..., iov_len=128}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = 128
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, 0) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6, "\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, -1) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\2\1\1\n\0\0\0\1\0\0\0=\0\0\0", iov_len=16}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\6\1s\0\5\0\0\0:1.28\0\0\0\5\1u\0\1\0\0\0\10\1g\0\1s\0\0"..., iov_len=74}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 74
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6, "\3\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(7, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... poll resumed>) = 1 ([{fd=7, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(7,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... read resumed>"\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(7, "\1\0\0\0\0\0\0\0", 8 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... recvmsg resumed>{msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\4\1\1\n\0\0\0\2\0\0\0\215\0\0\0", iov_len=16}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... write resumed>) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x1209a7120, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(7 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... close resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\1\1o\0\25\0\0\0/org/freedesktop/DBus\0\0\0"..., iov_len=154}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 154
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... openat resumed>) = 7
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(7, {st_mode=S_IFREG|0644, st_size=2997, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(7, "# Locale name alias data base.\n#"..., 8192) = 2997
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(7, "", 8192)  = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(7 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... write resumed>) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... close resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, -1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/etc/fprintd.conf", O_RDONLY <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6, "\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, -1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... openat resumed>) = 7
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(7, {st_mode=S_IFREG|0644, st_size=20, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(7, "[storage]\ntype=file\n", 4096) = 20
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(7, "", 4096)  = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(7)           = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 rt_sigaction(SIGTERM, {sa_handler=0x7fffb72f37c0, sa_mask=[], sa_flags=SA_RESTART|SA_NOCLDSTOP}, NULL, 8) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/proc/bus/usb", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/dev", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 7
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(7, {st_mode=S_IFDIR|0755, st_size=3260, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x1209c0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(0x1209f0000)   = 0x1209f0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(7, 0x1209b4240 /* 163 entries */, 65536) = 4696
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(7, 0x1209b4240 /* 0 entries */, 65536) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x1209f0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x1209f0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(0x1209e0000)   = 0x1209e0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x1209e0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(7)           = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 uname({sysname="Linux", nodename="ltcden8-lp6.aus.stglabs.ibm.com", ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 stat("/sys/bus/usb/devices", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 access("/run/udev/control", F_OK) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 socket(AF_NETLINK, SOCK_RAW|SOCK_CLOEXEC|SOCK_NONBLOCK, NETLINK_KOBJECT_UEVENT) = 7
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 setsockopt(7, SOL_SOCKET, SO_ATTACH_FILTER, {len=10, filter=0x7fffcb0b31b8}, 16) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 bind(7, {sa_family=AF_NETLINK, nl_pid=0, nl_groups=0x000002}, 12) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getsockname(7, {sa_family=AF_NETLINK, nl_pid=2658, nl_groups=0x000002}, [12]) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 setsockopt(7, SOL_SOCKET, SO_PASSCRED, [1], 4) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(7, F_GETFD)  = 0x1 (flags FD_CLOEXEC)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(7, F_GETFL)  = 0x802 (flags O_RDWR|O_NONBLOCK)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 pipe2([8, 9], O_CLOEXEC) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(9, F_GETFL)  = 0x1 (flags O_WRONLY)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(9, F_SETFL, O_WRONLY|O_NONBLOCK) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 mmap(NULL, 8454144, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x7fff9f7f0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 mprotect(0x7fff9f800000, 8388608, PROT_READ|PROT_WRITE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 clone(child_stack=0x7fff9fffe410, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID/usr/bin/strace: Process 2730 attached
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: , parent_tid=[2730], tls=0x7fffa00062e0, child_tidptr=0x7fff9fffec40) = 2730
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getpid( <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2730] 05:58:18 set_robust_list(0x7fff9fffec50, 24 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... getpid resumed>) = 2658
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2730] 05:58:18 <... set_robust_list resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 gettid( <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2730] 05:58:18 poll([{fd=8, events=POLLIN}, {fd=7, events=POLLIN}], 2, -1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... gettid resumed>) = 2658
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getrandom("\x5f\x62\x22\x4c\x85\x3a\x4a\xb5\xe2\x79\x2a\x49\xc2\xc8\x1c\x1e", 16, GRND_NONBLOCK) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 access("/sys/subsystem", F_OK) = -1 ENOENT (No such file or directory)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/sys/bus", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 10
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(10, 0x1209c4250 /* 33 entries */, 65536) = 936
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/usr/lib64/gconv/gconv-modules.cache", O_RDONLY) = 11
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(11, {st_mode=S_IFREG|0644, st_size=26998, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 mmap(NULL, 26998, PROT_READ, MAP_SHARED, 11, 0) = 0x7fffb7420000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(11)          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb3c01a40, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/sys/bus/usb/devices/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 11
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(11, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x1209e0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(0x120a10000)   = 0x120a10000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(11, 0x1209d4290 /* 2 entries */, 65536) = 48
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(11, 0x1209d4290 /* 0 entries */, 65536) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x120a10000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x120a10000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(0x120a00000)   = 0x120a00000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x120a00000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(11)          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(10, 0x1209c4250 /* 0 entries */, 65536) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x120a00000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(0x1209f0000)   = 0x1209f0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 brk(NULL)          = 0x1209f0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(10)          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 openat(AT_FDCWD, "/sys/class", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 10
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fstat(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(10, 0x1209c4250 /* 51 entries */, 65536) = 1512
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 getdents64(10, 0x1209c4250 /* 0 entries */, 65536) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 close(10)          = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 pipe2([10, 11], O_CLOEXEC) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(11, F_GETFL) = 0x1 (flags O_WRONLY)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 fcntl(11, F_SETFL, O_WRONLY|O_NONBLOCK) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(11, "\1", 1) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 timerfd_create(CLOCK_MONOTONIC, TFD_CLOEXEC|TFD_NONBLOCK) = 12
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 mmap(NULL, 8454144, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0) = 0x7fff9efe0000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 mprotect(0x7fff9eff0000, 8388608, PROT_READ|PROT_WRITE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 clone(child_stack=0x7fff9f7ee410, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID/usr/bin/strace: Process 2737 attached
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: , parent_tid=[2737], tls=0x7fff9f7f62e0, child_tidptr=0x7fff9f7eec40) = 2737
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 set_robust_list(0x7fff9f7eec50, 24) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 prctl(PR_SET_NAME, "GUsbEventThread"...) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 mmap(0x7fff9c000000, 67108864, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 recvmsg(7,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 <... mmap resumed>) = 0x7fff94000000
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... recvmsg resumed>{msg_namelen=128}, 0) = -1 EAGAIN (Resource temporarily unavailable)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 mprotect(0x7fff94000000, 196608, PROT_READ|PROT_WRITE <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 <... mprotect resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 read(10,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 <... read resumed>"\1", 1) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:18 poll([{fd=10, events=POLLIN}, {fd=12, events=POLLIN}], 2, 60000 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x7fffb7410ec0, FUTEX_WAKE_PRIVATE, 2147483647) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 poll([{fd=4, events=POLLIN}], 1, 25000 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... poll resumed>) = 1 ([{fd=4, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... read resumed>"\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(4, "\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 sendmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\1\0\1 \0\0\0\2\0\0\0}\0\0\0\10\1g\0\2su\0\1\1o\0\25\0\0\0"..., iov_len=176}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 poll([{fd=4, events=POLLIN}], 1, 25000 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... sendmsg resumed>) = 176
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, 0) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 dbus-daemon[1038]: [system] Successfully activated service 'net.reactivated.Fprint'
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, -1) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: Started Fingerprint Authentication Daemon.
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\4\1\1\33\0\0\0\3\0\0\0\215\0\0\0", iov_len=16}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\1\1o\0\25\0\0\0/org/freedesktop/DBus\0\0\0"..., iov_len=171}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 171
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6, "\3\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\1\0\1\0\0\0\0\2\0\0\0\226\0\0\0", iov_len=16}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\1\1o\0\37\0\0\0/net/reactivated/Fprint/"..., iov_len=152}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 152
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 mprotect(0x7fff98030000, 65536, PROT_READ|PROT_WRITE) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(4, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... poll resumed>) = 1 ([{fd=4, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(4,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... read resumed>"\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\2\1\1\4\0\0\0\4\0\0\0=\0\0\0", iov_len=16}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 16
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 futex(0x120997cf0, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... write resumed>) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 futex(0x120997cf0, FUTEX_WAKE_PRIVATE, 1) = 1
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 futex(0x120997cf0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 poll([{fd=4, events=POLLIN}], 1, 24999 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... futex resumed>) = 0
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0) = 1 ([{fd=5, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 recvmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="\6\1s\0\5\0\0\0:1.28\0\0\0\5\1u\0\2\0\0\0\10\1g\0\1u\0\0"..., iov_len=68}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_CMSG_CLOEXEC) = 68
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 sendmsg(5, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\2\1\1\4\0\0\0\3\0\0\0\36\0\0\0\10\1g\0\2ao\0\5\1u\0\2\0\0\0"..., iov_len=52}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = 52
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=6, events=POLLIN}], 1, 0) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6, "\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(4, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... poll resumed>) = 1 ([{fd=4, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}], 1, 0 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 read(4,  <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 <... poll resumed>) = 0 (Timeout)
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 <... read resumed>"\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 write(6, "\1\0\0\0\0\0\0\0", 8) = 8
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 poll([{fd=4, events=POLLIN}], 1, 30561 <unfinished ...>
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, -1) = 1 ([{fd=6, revents=POLLIN}])
Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 read(6, "\1\0\0\0\0\0\0\0", 16) = 8
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: pmie_farm_check.service: Succeeded.
Jun 30 05:58:18 ltcden8-lp6 systemd[1]: pmie_check.service: Succeeded.
Jun 30 05:58:21 ltcden8-lp6 systemd-logind[1079]: New session 3 of user root.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Starting Check and migrate non-primary pmie farm instances...
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Starting Check and migrate non-primary pmlogger farm instances...
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Starting Check pmlogger instances are running...
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Starting Check PMIE instances are running...
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Started Session 3 of user root.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Started Check and migrate non-primary pmie farm instances.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Started Check and migrate non-primary pmlogger farm instances.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Started Check PMIE instances are running.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: Started Check pmlogger instances are running.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: pmie_farm_check.service: Succeeded.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: pmlogger_farm_check.service: Succeeded.
Jun 30 05:58:21 ltcden8-lp6 systemd[1]: pmie_check.service: Succeeded.
Jun 30 05:58:22 ltcden8-lp6 systemd[1]: pmlogger_check.service: Succeeded.
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:18 poll([{fd=5, events=POLLIN}, {fd=6, events=POLLIN}], 2, -1 <unfinished ...>
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:48 <... poll resumed>) = 0 (Timeout)
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:48 exit_group(0)      = ?
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:48 <... poll resumed> <unfinished ...>) = ?
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:48 <... poll resumed> <unfinished ...>) = ?
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2730] 05:58:48 <... poll resumed> <unfinished ...>) = ?
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:48 <... poll resumed> <unfinished ...>) = ?
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2737] 05:58:48 +++ exited with 0 +++
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2730] 05:58:48 +++ exited with 0 +++
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2716] 05:58:48 +++ exited with 0 +++
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: [pid  2696] 05:58:48 +++ exited with 0 +++
Jun 30 05:58:48 ltcden8-lp6 strace[2585]: 05:58:48 +++ exited with 0 +++
Jun 30 05:58:48 ltcden8-lp6 systemd[1]: fprintd.service: Succeeded.

--Apple-Mail=_D77BF1E8-7974-4C36-9898-319F4CE0CFF3--

