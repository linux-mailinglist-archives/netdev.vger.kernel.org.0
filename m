Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7941928135
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbfEWPbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:31:16 -0400
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:64174 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730760AbfEWPbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:31:16 -0400
X-Sender-Id: dreamhost|x-authsender|wcarlson@wkks.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 7BCB65E1887
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 15:31:14 +0000 (UTC)
Received: from pdx1-sub0-mail-a91.g.dreamhost.com (100-96-95-11.trex.outbound.svc.cluster.local [100.96.95.11])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id AE3B45E1D3E
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 15:31:13 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|wcarlson@wkks.org
Received: from pdx1-sub0-mail-a91.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.2);
        Thu, 23 May 2019 15:31:14 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|wcarlson@wkks.org
X-MailChannels-Auth-Id: dreamhost
X-Continue-Interest: 74d12ece6875f64f_1558625474199_225217031
X-MC-Loop-Signature: 1558625474199:3646967219
X-MC-Ingress-Time: 1558625474199
Received: from pdx1-sub0-mail-a91.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a91.g.dreamhost.com (Postfix) with ESMTP id 510A57FAF8
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 08:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=wkks.org; h=to:reply-to
        :from:subject:message-id:date:mime-version:content-type
        :content-transfer-encoding; s=wkks.org; bh=Aa0sSgAkVBJ8xo9t3vHUA
        bqxZkA=; b=JOmk8zkfYH0f2h34zDmHaf1hbk+pNzGL+9yWanBlAMPuIXtsdBfrm
        bZVk9w28lcaMUVzWmo1zX6Hn0M7/0YVkEK2OjHotUhyFCPgaFo7iolcd0R+x9iCA
        8JcLW44TZ+Z8tLW5hmJe88Ufw0/CcB8uj/vT9zunDPZdgd3KI6gqMY=
Received: from blade.c.c (173-21-244-129.client.mchsi.com [173.21.244.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcarlson@wkks.org)
        by pdx1-sub0-mail-a91.g.dreamhost.com (Postfix) with ESMTPSA id BFAD27FAC7
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 08:31:10 -0700 (PDT)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Reply-To: billcarlson@wkks.org
X-DH-BACKEND: pdx1-sub0-mail-a91
From:   Bill Carlson <billcarlson@wkks.org>
Subject: bonding-devel mail list?
Message-ID: <3428f1e4-e9e9-49c6-8ca8-1ea5e9fdd7ed@wkks.org>
Date:   Thu, 23 May 2019 10:31:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgledvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpefvrhfhuffkffgfgggtgfesthejredttdefjeenucfhrhhomhepuehilhhlucevrghrlhhsohhnuceosghilhhltggrrhhlshhonhesfihkkhhsrdhorhhgqeenucfkphepudejfedrvddurddvgeegrdduvdelnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopegslhgruggvrdgtrdgtpdhinhgvthepudejfedrvddurddvgeegrdduvdelpdhrvghtuhhrnhdqphgrthhhpeeuihhllhcuvegrrhhlshhonhcuoegsihhllhgtrghrlhhsohhnseifkhhkshdrohhrgheqpdhmrghilhhfrhhomhepsghilhhltggrrhhlshhonhesfihkkhhsrdhorhhgpdhnrhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Noted the old bonding-devel mail list at sourceforge is no more, is 
there an alternate?

Chasing whether a bond of bonds has an issue my testing hasn't revealed.

Thanks,

-- 

Bill Carlson

Anything is possible, given Time and Money.

