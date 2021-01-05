Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C732EB12E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbhAERQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:16:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729242AbhAERQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 12:16:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A778B22CE3;
        Tue,  5 Jan 2021 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609866976;
        bh=yQj5OYq1HyrEPgStwVW/R/lhp92E/DhEX0ndvW4l9vw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gowhTC3ad0FJUT7dzpcthpNukxre+n/TuSpPw28n8MP4Ff4g/PULldtX8Ky2z+SMj
         AKDJ6sBCJhhdWwtP4eghcZWppzb92/HmXbJuecY8RtCts5IPB/u4OVGBxQltK5+EVP
         okpgb0PI9QBUYMdCkQ4aIfEvMfgx41JggJV1WkohlymOtMl1f7sALUHnxQWFPSGPoY
         0+lvtooNclU5ZbHnZsqY7HoM26cTa4FfkhWHP5LKe5TeB/+Lenz57MuydX0LtN2Jei
         +UfmrI/L4hQxrl59PmXHEvZfNemxa2sBDmyewRw0zee6Ll2iR1J1eS8zY8QW/CWK9n
         IrrlFmqRAAMrQ==
Date:   Tue, 5 Jan 2021 18:15:50 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next] net: mvneta: fix error message when MTU too
 large for XDP
Message-ID: <20210105181550.634980a8@kernel.org>
In-Reply-To: <20210105163833.389-1-kabel@kernel.org>
References: <20210105163833.389-1-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OMG, please ignore this, I thought that NL_SET_ERR_MSG_MOD takes printf
like arguments.
