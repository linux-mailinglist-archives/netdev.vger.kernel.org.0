Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7072D6E97CB
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjDTO7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjDTO7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D7B35AF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8DEB64A34
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30528C433EF;
        Thu, 20 Apr 2023 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682002784;
        bh=/D8ISpki4l1J4whygb9ubLZyEG1f518zP3ZWZthbXPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RNU4vKpt3/KIphM9zbptyAkV4k9sjA9q/cCcr3KgQi6jsSx4BLqR/gvbZeQJ+MCqH
         4nxXQ1/wlpVHSEBnHh7JAVV3Trcb6OmzGZwFaabVOG/wuzPvPZSKhds64WeB0cdxUn
         ie9rnvvJtx4cJw/bbhm75O8x17oWvAbtjtvQy3e37xwCEzvtzEAYLOOc6j1IUKisv9
         TtUvoFgvxmfaeHqKKjT0d+toQp5kIXbpraeDF2WGjLuqftkI2hQ1bC0YOwUJznTFaY
         Ji9TJ12/DhsxqeoLASnjW17MKyeTGOfI8bZuc9uAPWM+mGf9KwObfVQSoJqT6Qc1HA
         6cyv+ycDFrEIQ==
Date:   Thu, 20 Apr 2023 07:59:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Ahmed Zaki <ahmed.zaki@intel.com>,
        <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next] iavf: remove double
 underscores from states names
Message-ID: <20230420075943.4ef9b68a@kernel.org>
In-Reply-To: <21b89328-8c74-596b-3cfe-e71affd193a8@intel.com>
References: <20230419231751.11581-1-ahmed.zaki@intel.com>
        <21b89328-8c74-596b-3cfe-e71affd193a8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 16:33:54 +0200 Alexander Lobakin wrote:
> > No need to prepend some states names with "__", especially that others do
> > not have these underscores.  
> 
> What's the value of this change, apart from 400 locs diffstat? I don't
> say having prefixes for general-purpose definitions is correct, but...
> Dunno. Would be nice to have as a part of some series with assorted
> improvements, but not standalone. Or it's just me =\

Yeah, I'm not sure it's bad enough to justify the code churn, either.
Up to you folks at Intel.
