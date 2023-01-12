Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15C366870E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbjALWg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbjALWg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:36:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EBD5FBD
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DB7ACE1FC1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EABBC433F0;
        Thu, 12 Jan 2023 22:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673562980;
        bh=p1f79uxjJxfXlVIc0OKeEp/xAlgHr76Bz6yH9MkpASg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NbBO2HqqwGA01/a3qMUZITpYvhEWh7NNcT4Mt7aqurrY61wUrSaDHY9wLkhynAv22
         Kfu4xSacunYDT1KFc3HpbObcqV9CBxUIURtcxmJL8npBqpLTapy9qe0Z3E74lun5TP
         VgJxKJ3UJlDElE1xOr1/6PwpzQfJiVdKE1FaMuA1YLm238E/6EMwWX+gFw/oIKdVUi
         sgfitria8guGeUPZ/YVV+DxWHw3ZDN28Bk3LJobX0vI9DaWnCiOjLvqXdGDJIhj/eH
         +jMAhYw3HgrPs77EodxG91u6YDab3LyaybKypflChj2QqGSTuY7WTmk9fal1QFXsf6
         vXStDVN9Ds0rA==
Date:   Thu, 12 Jan 2023 14:36:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Raju Rangoju <Raju.Rangoju@amd.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH net 0/2] amd-xgbe: PFC and KR-Training fixes
Message-ID: <20230112143619.5f7e7ed0@kernel.org>
In-Reply-To: <822b51ba-3012-6084-b4eb-39e21f2c066a@amd.com>
References: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
        <20230111214254.4e5644a4@kernel.org>
        <822b51ba-3012-6084-b4eb-39e21f2c066a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Jan 2023 11:19:34 +0530 Shyam Sundar S K wrote:
> I have put an Ack tag to the patches in the series, being the additional
> maintainer for this driver. As Tom is busy working on other areas, I
> shall be a single maintainer for this driver going forward.
> 
> I can submit a patch for the change to the MAINTAINERS file.

For Fixes of code that someone authored it'd be better if the person 
is CCed, as long as their email address still works. For net-next
material, if you're posting as a co-maintainer not CCing other
maintainers is no big deal.

> But would you mind pulling this series for now? Or would you like to see
> the MAINTAINERS file getting updated first?

Yes, no need to repost this one. Just something to keep in mind for 
the future.
