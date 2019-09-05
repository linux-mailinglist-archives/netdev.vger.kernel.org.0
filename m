Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574BAAA3DA
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389721AbfIENEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:04:41 -0400
Received: from fgont.go6lab.si ([91.239.96.14]:42400 "EHLO fgont.go6lab.si"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfIENEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 09:04:41 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2019 09:04:40 EDT
Received: from [192.168.1.14] (ppp-94-69-228-25.home.otenet.gr [94.69.228.25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by fgont.go6lab.si (Postfix) with ESMTPSA id 919118621E;
        Thu,  5 Sep 2019 14:56:39 +0200 (CEST)
From:   Fernando Gont <fgont@si6networks.com>
Subject: IPv6 temporary addresses (Fwd: New Version Notification for
 draft-ietf-6man-rfc4941bis-03.txt)
To:     netdev <netdev@vger.kernel.org>
References: <156768734939.22666.4804883631217307240.idtracker@ietfa.amsl.com>
Openpgp: preference=signencrypt
Message-ID: <ecbc3e8e-d35f-6ff8-d8b4-e8398856bbeb@si6networks.com>
Date:   Thu, 5 Sep 2019 15:56:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156768734939.22666.4804883631217307240.idtracker@ietfa.amsl.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

We are working in a revision of RFC4941 (temporary addresses), to
address issues found in such spec -- for example, RFC4941 leads to the
same interface identifiers being employed for different prefixes (which
of course has privacy implications)

The current version of the revised spec is available at:
https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis

We'd really like to hear your comments and double-check if we got
everything right, if there's something that we missed, etc.

If possible, please post your feedback on the 6man list
(https://www.ietf.org/mailman/listinfo/ipv6). But I'll be happy to
receive comments here or unicast and relay them as necessary.

Thanks!

Cheers,
Fernando




-------- Forwarded Message --------
Subject: New Version Notification for draft-ietf-6man-rfc4941bis-03.txt
Date: Thu, 05 Sep 2019 05:42:29 -0700
From: internet-drafts@ietf.org
To: Fernando Gont <fgont@si6networks.com>, Suresh Krishnan
<suresh.krishnan@ericsson.com>, Richard Draves <richdr@microsoft.com>,
Thomas Narten <narten@us.ibm.com>


A new version of I-D, draft-ietf-6man-rfc4941bis-03.txt
has been successfully submitted by Fernando Gont and posted to the
IETF repository.

Name:		draft-ietf-6man-rfc4941bis
Revision:	03
Title:		Privacy Extensions for Stateless Address Autoconfiguration in IPv6
Document date:	2019-09-05
Group:		6man
Pages:		21
URL:
https://www.ietf.org/internet-drafts/draft-ietf-6man-rfc4941bis-03.txt
Status:         https://datatracker.ietf.org/doc/draft-ietf-6man-rfc4941bis/
Htmlized:       https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-03
Htmlized:
https://datatracker.ietf.org/doc/html/draft-ietf-6man-rfc4941bis
Diff:
https://www.ietf.org/rfcdiff?url2=draft-ietf-6man-rfc4941bis-03

Abstract:
   Nodes use IPv6 stateless address autoconfiguration to generate
   addresses using a combination of locally available information and
   information advertised by routers.  Addresses are formed by combining
   network prefixes with an interface identifier.  This document
   describes an extension that causes nodes to generate global scope
   addresses with randomized interface identifiers that change over
   time.  Changing global scope addresses over time makes it more
   difficult for eavesdroppers and other information collectors to
   identify when different addresses used in different transactions
   actually correspond to the same node.  This document formally
   obsoletes RFC4941.




Please note that it may take a couple of minutes from the time of submission
until the htmlized version and diff are available at tools.ietf.org.

The IETF Secretariat


