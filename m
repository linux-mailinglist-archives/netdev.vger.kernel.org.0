Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133F56E135C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDMRUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDMRUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:20:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899A726A6;
        Thu, 13 Apr 2023 10:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fNOeiHpE9GuUd/CgeBnmqsgNJaFNj045OFJkweHv/lI=; b=AHZOT0sVyYYUIArFlnDLgxcsfk
        XudFvfVO3XnBIamADUvocCTBqjqZHcLwQK3zYPMZg4Iapi8ekvqZCP6Fl3XujHpDztUV2ExCVEQvF
        8R0hnr2ny5wR7mwiR+dcxy7H6y/Y9tllYfABG5lepEgugV5mGCfDhZTk4R0FbNo8hy3c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pn0cC-00ADL9-3L; Thu, 13 Apr 2023 19:20:08 +0200
Date:   Thu, 13 Apr 2023 19:20:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ladislav Michl <oss-lists@triops.cz>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] staging: octeon: avoid needless device allocation
Message-ID: <e2f5462d-5573-483c-9428-5f2b052cf939@lunn.ch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgOLHw1IkmWVU79@lenoch>
 <543bfbb6-af60-4b5d-abf8-0274ab0b713f@lunn.ch>
 <ZDgxPet9RIDC9Oz1@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDgxPet9RIDC9Oz1@lenoch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I was asking this question myself and then came to this:
> Converting driver to phylink makes separating different macs easier as
> this driver is splitted between staging and arch/mips/cavium-octeon/executive/
> However I'll provide changes spotted previously as separate preparational
> patches. Would that work for you?

Is you end goal to get this out of staging? phylib vs phylink is not a
reason to keep it in staging.

It just seems odd to be adding new features to a staging driver. As a
bit of a "carrot and stick" maybe we should say you cannot add new
features until it is ready to move out of staging?

But staging is not my usual domain.

	 Andrew
