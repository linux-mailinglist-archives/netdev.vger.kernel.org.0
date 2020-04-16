Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B682F1AC34C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898220AbgDPNkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:40:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898166AbgDPNko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:40:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GDcKwv084649;
        Thu, 16 Apr 2020 13:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=+FwckwE718nnFr/35g3gcj/92E89oTBl1ZMCTR5KEIM=;
 b=iqUrY2H9ib6Tqb8czeWAPq4BibUWiDCpkkPRWOnjSVYxuYoossgOsmNXjtBStklxsrN/
 BOrP9qPYV44t2frUqNHruNf9bA99+R1qP05U+WRC7YzNrDD4UzCq2QgGT4EAt3bshHe6
 uvecHlGvvSUAozs7pESH75q4v9OcVMlmTfFEh0f+eEkP2GqqF+jBS5y6ULF4Gts0ilKP
 UQfVBSJ7cQ7MzwTlxH2YR1ArDYswN+/zbvf8AinEnvTOh0UOv/IUc/kzXkl9LS1QrkrD
 UccoJqRh/62a5sd4sXPR5SXu9rhd4Vp7QE2zsD71SkinXrPHQBHbDi4LQL4ew9aox85j 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30dn95sfm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 13:40:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GDc55R134095;
        Thu, 16 Apr 2020 13:40:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30dynyqbr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 13:40:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03GDeWWD019065;
        Thu, 16 Apr 2020 13:40:32 GMT
Received: from anon-dhcp-153.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Apr 2020 06:40:32 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: What's a good default TTL for DNS keys in the kernel
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <128769.1587032833@warthog.procyon.org.uk>
Date:   Thu, 16 Apr 2020 09:40:30 -0400
Cc:     Florian Weimer <fweimer@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8DC44895-E904-4155-B7B8-B109A777F23C@oracle.com>
References: <874ktl2ide.fsf@oldenburg2.str.redhat.com>
 <3865908.1586874010@warthog.procyon.org.uk>
 <128769.1587032833@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David-

> On Apr 16, 2020, at 6:27 AM, David Howells <dhowells@redhat.com> =
wrote:
>=20
> Florian Weimer <fweimer@redhat.com> wrote:
>=20
>> You can get the real TTL if you do a DNS resolution on the name and
>> match the addresses against what you get out of the NSS functions.  =
If
>> they match, you can use the TTL from DNS.  Hackish, but it does give =
you
>> *some* TTL value.
>=20
> I guess I'd have to do that in parallel.  Would calling something like
> res_mkquery() use local DNS caching?
>=20
>> The question remains what the expected impact of TTL expiry is.  Will
>> the kernel just perform a new DNS query if it needs one?  Or would =
you
>> expect that (say) the NFS client rechecks the addresses after TTL =
expiry
>> and if they change, reconnect to a new NFS server?
>=20
> It depends on the filesystem.

Agreed. For example:

The Linux NFS client won't connect to a new server when the server's
DNS information changes. A fresh mount operation would be needed for
the client to recognize and make use of it.

There are mechanisms in the NFSv4 protocol to collect server IP =
addresses
from the server itself (fs_locations) and then try those locations if =
the
current server fails to respond. But currently that is not implemented =
in
Linux (and servers would need to be ready to provide that kind of =
update).


> AFS keeps track of the expiration on the record and will issue a new =
lookup
> when the data expires, but NFS doesn't make use of this information.  =
The
> keyring subsystem will itself dispose of dns_resolver keys that expire =
and
> request_key() will only upcall again if the key has expired.

Our NFS colleagues working on Solaris have noted that handling the =
expiry
of DNS information can be tricky. It is usually desirable to continue =
using
expired information when a new DNS query fails temporarily (times out, =
or
the network is partitioned, etc). That makes for a more robust network =
file
service.


> The problem for NFS is that the host IP address is the primary key for =
the
> superblock (see nfs_compare_super_address()).

I thought that NFSv4.1 and newer have server-provided unique information
that might be used in place of the server's IP address. This information
is supposed to be independent of a server's network addresses.


> CIFS also doesn't make direct use of the TTL, and again this may be =
because it
> uses the server address as part of the primary key for the superblock =
(see
> cifs_match_super()).

--
Chuck Lever



