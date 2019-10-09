Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F02D06C7
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfJIEyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:54:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51471 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729040AbfJIEyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:54:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F2EA21BF7;
        Wed,  9 Oct 2019 00:54:47 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Wed, 09 Oct 2019 00:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm3; bh=GYDZ/b1NmG3l2/a+1VqeDxOxhBTndMr
        U35mxyi0iu7Q=; b=PHlV9mChdJPTvcXKOCtcfvolYH+sDhhOmJECUZBikxZ2Ucn
        z78OemKYOQCfMA9euBLvFn6wtTjiKWNBzsmzbYkeURI78AR4RqZxmqq5Q8bx0gso
        c9TC2y0drk7HrBXi1kQE8CT4y8VZyoUwjAAKcQuQkjfvrhvNiqEfrkKu5GMnIrkF
        ZFi37dG2QTBn3umOyiLBPH1P7vcLNjtERjphORvyhVFIHK7y+O9UCLLfzeOjJNj0
        nhMrImvWofCghFjJLSmidLpOKZRjUmoR4xfpbKuQRMfa7vHvEnuv+23H4ds9YlrA
        8SbO9FAkVQ8qhIVIgfw2jnIiIZ3M1q3BGz1ztBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GYDZ/b
        1NmG3l2/a+1VqeDxOxhBTndMrU35mxyi0iu7Q=; b=a3C3adIaH5OUXA7UWlYnZd
        TFjkiNqLghOz5TKDbJxFcoB8AwAecTesvTdrVjGvRH33xPjWIXTH/Ili2gj6RNsC
        qUJnGEFkp5w47/9+fMZ9YgHZDCl57fpRIUy0fcm1QwCJaf4tI9DFuIVE9+xvZ7MQ
        URtEPuaRUJOfml6ptjLJRJ+wDLdAKL3miuf84/Y/w1z1wrOl3lZNEzTmcGzXUVow
        OKXkGJvtK48px7TWgA12TgfSvZBp+AALFq+rooM3KZ7h0LNr/TAVQvbJOoSKh5Gt
        Nu6/dO/SXSMRxIbmHodbooORCq2Oy/zi23l9ansrIz605ZvAELyYYxabCSOcgB8g
        ==
X-ME-Sender: <xms:FmidXTnsucnIlJ7N4XasiYJaII4XIrC3L3LZKDwfe5TYpcrFji4hgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucfrrghrrg
    hmpehmrghilhhfrhhomheprghnughrvgifsegrjhdrihgurdgruhenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:FmidXVGC2Cqes3HyAP5hQZsdir6STKf6WwURVs97vJqGKx2Ij3mU_w>
    <xmx:FmidXWzDfwfFCfL-IF2EiEgCuodoEXoFzj4iDov8ReAUZYxWTS78jg>
    <xmx:FmidXeaHZ9W-64BoEyw1o1Ixx3F9_6f2wns45a3zMX5zE_ip7_iUfQ>
    <xmx:F2idXXz1-luQqtlZvI_zlw88ajN-mFZNEqqWpKbvw0M-G1uODeWvYQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7EE8FE00A6; Wed,  9 Oct 2019 00:54:46 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-360-g7dda896-fmstable-20191004v2
Mime-Version: 1.0
Message-Id: <4998960d-6125-4402-9905-869653a84e52@www.fastmail.com>
In-Reply-To: <6f70580a-4b4b-45e0-8899-8a74f9587002@www.fastmail.com>
References: <20191008115143.14149-1-andrew@aj.id.au>
 <20191008115143.14149-2-andrew@aj.id.au>
 <75d915aec936be64ea5ebd63402efd90bb1c29d9.camel@kernel.crashing.org>
 <6f70580a-4b4b-45e0-8899-8a74f9587002@www.fastmail.com>
Date:   Wed, 09 Oct 2019 15:25:40 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        netdev <netdev@vger.kernel.org>
Cc:     "David Miller" <davem@davemloft.net>,
        "Rob Herring" <robh+dt@kernel.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Joel Stanley" <joel@jms.id.au>
Subject: =?UTF-8?Q?Re:_[PATCH_1/3]_dt-bindings:_net:_ftgmac100:_Document_AST2600_?=
 =?UTF-8?Q?compatible?=
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 9 Oct 2019, at 15:19, Andrew Jeffery wrote:
> 
> 
> On Wed, 9 Oct 2019, at 15:08, Benjamin Herrenschmidt wrote:
> > On Tue, 2019-10-08 at 22:21 +1030, Andrew Jeffery wrote:
> > > The AST2600 contains an FTGMAC100-compatible MAC, although it no-
> > > longer
> > > contains an MDIO controller.
> > 
> > How do you talk to the PHY then ?
> 
> There are still MDIO controllers, they're just not in the MAC IP on the 2600.

Sorry, on reflection that description is a little ambiguous in its use of 'it'. I'll
fix that in v2 as well. Does this read better?

"The AST2600 contains an FTGMAC100-compatible MAC, although the MAC
no-longer contains an MDIO controller."

Andrew
