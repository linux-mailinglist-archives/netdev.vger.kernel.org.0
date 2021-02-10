Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3DB31709C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhBJTva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232459AbhBJTvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 14:51:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC6164ED4;
        Wed, 10 Feb 2021 19:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612986643;
        bh=DMCWUuwZO8nCkkKk62bJyf0P2K6CJcMPltVA7oTu5gA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RlfYtuoLje+Gl3HmSy7uSoiooY611BC7m+J27QBQyqiOd5EBYbeR4fzq09pvRrBH3
         V47s7vVQ5/thSxpWPjxtemIQrTDbdOtn08kbO9ws+cvrcoXdB/7W9MAtvfGoXu6HJv
         kZQlCL6xLa5UctdWmksutcHzqlmuaGzHFfP/JbDYVlCo9QNPs7lXVVfbNhUQUKnLCV
         XBXGTcZNnCPv9Emks7jsEGAYf9v6MpyaFMxjj2a0ZFtunddrdthVhhC+ruZ1kFILZs
         4uBm08/AHGVKhGTelZlrV7YC7vVX0zyblE/whjkqcG4lJNwcu3sdsKAghuXfI5oebs
         +J4KTxuzIKMvQ==
Date:   Wed, 10 Feb 2021 11:50:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v4 net-next 0/7] ethtool support for fec and link
 configuration
Message-ID: <20210210115042.77c40c09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MWHPR18MB1421079657254DAD7B37000ADE8D9@MWHPR18MB1421.namprd18.prod.outlook.com>
References: <MWHPR18MB1421079657254DAD7B37000ADE8D9@MWHPR18MB1421.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 17:06:29 +0000 Hariprasad Kelam wrote:
> > On Tue, 9 Feb 2021 16:05:24 +0530 Hariprasad Kelam wrote:  
> > > v4:
> > > 	- Corrected indentation issues
> > > 	- Use FEC_OFF if user requests for FEC_AUTO mode
> > > 	- Do not clear fec stats in case of user changes
> > > 	  fec mode
> > > 	- dont hide fec stats depending on interface mode
> > > 	  selection  
> > 
> > What about making autoneg modes symmetric between set and get?  
> 
> Get supports multi modes such that user can select one of the modes
> to advertise. For time being set only supports single mode. Do let me
> know if you want me to Add this in commit description.

You use the same code for supported and advertising.
Please add a check that there is only one advertising mode 
reported so we don't have to take your word for it.

Thanks.
