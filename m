Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB77AC46A1
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 06:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfJBEc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 00:32:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47918 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfJBEc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 00:32:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A0C7A608CC; Wed,  2 Oct 2019 04:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990747;
        bh=TcvDj3Q5RUu13Sd8E2UL9tT6L2exfdkRAjTNMgjnipg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dXnP11btiyK7xoI6th0r1PYZizOODorIEcSrQa2yhGxKNKgAUKkaH743hUQyreVqp
         bx/2mzwXxEHLKTJwQc980Obum75HEbR805t5hS7adMfJgLNdUBVBHmofU+y6JmZA91
         oGkWC0bQ3Hr193Va7xQeJrt9rIyTM89hxxzDdcsE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25B5A608CE;
        Wed,  2 Oct 2019 04:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990747;
        bh=TcvDj3Q5RUu13Sd8E2UL9tT6L2exfdkRAjTNMgjnipg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZF6OvQYRG8xVjoCwlC9uPhWXKholwaDeEsO0aPnL59WlfaNXXu796NFg5TbHOqt07
         LXohoyFOyIRlEys8U9x8AHLyX4zluJW/+0zd89RWDxvuEDglC0U48GJ1Yjg+QKty0n
         BHbk2oYIux6LZdPqNyqTqAlkR/SJ7CNCNWhX3JRk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 25B5A608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: prevent leaking urb
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190920030043.30137-1-navid.emamdoost@gmail.com>
References: <20190920030043.30137-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) emamd001@umn.edu,
        smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)emamd001@umn.edu
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002043227.A0C7A608CC@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 04:32:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In rtl8xxxu_submit_int_urb if usb_submit_urb fails the allocated urb
> should be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Reviewed-by: Chris Chiu <chiu@endlessm.com>

Patch applied to wireless-drivers-next.git, thanks.

a2cdd07488e6 rtl8xxxu: prevent leaking urb

-- 
https://patchwork.kernel.org/patch/11153733/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

