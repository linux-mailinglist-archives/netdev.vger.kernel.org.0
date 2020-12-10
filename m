Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0192D6138
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403833AbgLJQIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:08:49 -0500
Received: from spam.lhost.no ([5.158.192.85]:55591 "EHLO mx04.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390129AbgLJQIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 11:08:46 -0500
X-ASG-Debug-ID: 1607616473-0ffc06424c350c60001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx04.lhost.no with ESMTP id VbuvdntWvopKgi3N (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Thu, 10 Dec 2020 17:07:54 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Thu, 10
 Dec 2020 17:07:52 +0100
Subject: Re: [PATCH iproute2-next v1] iplink macvlan: Added bcqueuelen
 parameter
To:     Jakub Kicinski <kuba@kernel.org>, <stephen@networkplumber.org>
X-ASG-Orig-Subj: Re: [PATCH iproute2-next v1] iplink macvlan: Added bcqueuelen
 parameter
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <80f814c3-0957-7f65-686c-f5fbb073f65c@paneda.se>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <6f97161f-68a1-7224-18ac-ce221c7c2c5e@paneda.se>
Date:   Thu, 10 Dec 2020 17:07:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <80f814c3-0957-7f65-686c-f5fbb073f65c@paneda.se>
Content-Type: text/plain; charset="utf-8"
Content-Language: sv
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1607616474
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx04.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 722
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-30 15:23, Thomas Karlsson wrote:
> This is a follow up patch to iproute2 that allows the user
> to set and retrieve the added IFLA_MACVLAN_BC_QUEUE_LEN parameter
> via the bcqueuelen command line argument
> 
> 
> v1 Initial version
>    Note: This patch first requires that the corresponding
>    kernel patch in 0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se
>    to macvlan is merged to be usable.

Just to follow up so this one isn't forgotten. The macvlan patch was merged
into net-next a week ago, commit d4bff72c8401e6f56194ecf455db70ebc22929e2

So this patch should be ready for review/incusion I think.

(Only sending this message since I noticed the patch was archived in patchworks).
