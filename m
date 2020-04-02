Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3DC19BF9F
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbgDBKsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 06:48:37 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:42311 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728612AbgDBKsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 06:48:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B600958026F;
        Thu,  2 Apr 2020 06:48:35 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute3.internal (MEProxy); Thu, 02 Apr 2020 06:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm2; bh=+D7VcHcSiM0jYaijsTuec/8aXp01c7Q
        cNu1qwr7scf8=; b=iJRHq44ZjRiN+PUDGv0B0SkOys1S3JYTIdGtOwy4SQeGevr
        idfuVTTpg1ueU5+aBep9iVkp1c47vpcLuVSlSzDZhOWwVkJXFl+7AyrdXBb4Sc5A
        JLQN1ZvN8M85yJrud1dK1KRWRgHN90XfChPidLn/XQBJCSh/befplS3r+ZelM5XE
        egFBa2eX9d9xBAWHZG2q+mAc8pMuy4iDTD8lsziox9d33h73QFSxrsxZMtfhnNiD
        DUPdfx3NSuAzKAJR3GdRQU06x28y6NWXDilwlMOBt3SiaWO2i/zd48LAiTFsal4X
        MflU3kp+fEBe8a/56o6nTM+Q9bQ4f7AZ61SzVmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+D7VcH
        cSiM0jYaijsTuec/8aXp01c7QcNu1qwr7scf8=; b=xGnG1PMP8tOJZe4fOzGtzC
        rv7vzrM8CQ8o6tdS4yJYLWzQ1MZsSC6xH6vadcDa6KKgpo5i10/PqckZxOLENMNX
        bq9B4n+iE47v9O9IMyxfdr3Gblydce/ypRXQ9YdEtqd8xM591VqkFr5RPKummpn1
        hv9j1A2V1vmZW9ZTqkeICieKJVDucDtVgffEqyVW2xZ7vrBjVhiKN+/2QnpEgyH6
        kLzkEqEMc1tUSoSkMuyU+xcoNDN0esN+sJ2UoWwwC2W4wXnW19p12tiiiIn3FEuv
        OTCOtJZimHpWz9MqG58du8yWDZVAKs2U/MlR7NBV3X/YjqLqf/rMn1JY1b5GSNLA
        ==
X-ME-Sender: <xms:AMOFXldeEkjXsJ7diQipgn0qxovg0PlDuheJ-E2ZX1ildObUqRyzyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvfiesrghj
    rdhiugdrrghu
X-ME-Proxy: <xmx:AMOFXvo5Ns1q9RuY6hGg-kPWZwS-cmt3iNEOQLVeNKZaJQKkRMufDw>
    <xmx:AMOFXtYQBjqP-aRB503nTiPDl6hqDf1cLloQDFhbWLGu3r1wHexa1A>
    <xmx:AMOFXlF7RSbA1HXjtdv1YjiqS_Hd-43ak8oAV2G99u8OiNAmy88X4Q>
    <xmx:A8OFXpdSmb-NEB1_q8gS7lmd4eNPdo2SpKRqDW2UZXoYEVEoQ0Mieg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 43330E00B9; Thu,  2 Apr 2020 06:48:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-1080-gca5de7b-fmstable-20200402v5
Mime-Version: 1.0
Message-Id: <9d9120dd-31c9-4cd8-bb91-c6350febb8ad@www.fastmail.com>
In-Reply-To: <1947a3705a220ce14a2fda482c833b38a4d9fe9a.camel@kernel.crashing.org>
References: <20200401105624.17423-1-xianfengting221@163.com>
 <1947a3705a220ce14a2fda482c833b38a4d9fe9a.camel@kernel.crashing.org>
Date:   Thu, 02 Apr 2020 21:18:44 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Hu Haowen" <xianfengting221@163.com>,
        "David Miller" <davem@davemloft.net>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>
Cc:     stfrench@microsoft.com, chris@chris-wilson.co.uk,
        xiubli@redhat.com, airlied@redhat.com, tglx@linutronix.de,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: =?UTF-8?Q?Re:_[PATCH]_net/faraday:_fix_grammar_in_function_ftgmac100=5Fs?=
 =?UTF-8?Q?etup=5Fclk()_in_ftgmac100.c?=
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 2 Apr 2020, at 21:13, Benjamin Herrenschmidt wrote:
> On Wed, 2020-04-01 at 18:56 +0800, Hu Haowen wrote:
> > "its not" is wrong. The words should be "it's not".
> > 
> > Signed-off-by: Hu Haowen <xianfengting221@163.com>
> 
> Typo more than grammer :-)
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
>  (the offender) 

No, I am Spartacus!

But yeah:

Acked-by: Andrew Jeffery <andrew@aj.id.au>
