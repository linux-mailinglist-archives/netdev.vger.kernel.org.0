Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4F21F187B
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgFHMIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:08:07 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:43472 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbgFHMIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:08:07 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2020 08:08:05 EDT
Received: from [192.168.2.100] (pub082136126227.dh-hfc.datazug.ch [82.136.126.227])
        by mail.strongswan.org (Postfix) with ESMTPSA id 7099F400F7;
        Mon,  8 Jun 2020 14:02:45 +0200 (CEST)
Subject: Re: [PATCHv2 ipsec] xfrm: fix a warning in xfrm_policy_insert_list
To:     Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>, yuehaibing@huawei.com,
        Andreas Steffen <andreas.steffen@strongswan.org>
References: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
From:   Tobias Brunner <tobias@strongswan.org>
Autocrypt: addr=tobias@strongswan.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <70458451-6ece-5222-c46f-87c708eee81e@strongswan.org>
Date:   Mon, 8 Jun 2020 14:02:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steffen, Xin,

This change could be problematic.  Actually, it's not really this one
but the original one that causes the issue:
> Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")

However, because the code in xfrm_policy_mark_match() treated policies
with the same mark/mask equal without considering the priority before
this change, it wasn't apparent.  The problem is that the code can now
lead to duplicate policies, which can not correctly be removed or queried.

That's because the priority is sent only in xfrm_userpolicy_info, which
XFRM_MSG_NEWPOLICY and XFRM_MSG_UPDPOLICY expect, but not in
xfrm_userpolicy_id, which is used to query and delete policies with
XFRM_MSG_GETPOLICY and XFRM_MSG_DELPOLICY, respectively (the mark is
sent with a separate attribute, which can be supplied to all commands).
 So we can only query/delete the duplicate policy with the highest
priority.  Such duplicates can even be created inadvertently via
XFRM_MSG_UPDPOLICY if the priority of an existing policy should be
changed, which worked fine so far.

The latter currently happens when strongSwan e.g. replaces a trap or
block policy with one that has templates assigned (those we install with
a higher priority, by default), which uses XFRM_MSG_UPDPOLICY that
doesn't update the existing policy anymore but creates a duplicate
instead.  Since only one XFRM_MSG_DELPOLICY is sent later when the
policy is deleted, a duplicate policy remains (and we couldn't even
delete the exact policy we wanted - the trap might be removed by the
user before the regular policy - due to the missing priority field in
xfrm_userpolicy_id).

I guess we could workaround this issue in strongSwan by installing
policies that share the same mark and selector with the same priority,
so only one instance is ever installed in the kernel.  But the inability
to address the exact policy when querying/deleting still looks like a
problem to me in general.

Regards,
Tobias
