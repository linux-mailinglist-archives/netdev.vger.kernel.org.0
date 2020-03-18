Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF7018A342
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 20:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCRTmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 15:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRTmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 15:42:23 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7D920752;
        Wed, 18 Mar 2020 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584560543;
        bh=gnyjozfggCEd6Y1BMEbwLru7Z3xCgOXzKiLv2BJ4mnc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o29QzWvAzML9H1wGdTXL98Y3qkP0tp1T+S1nUoZ/1IbF20mH2UxaHF7lj2SOz4xQL
         tV48ylP35eYvYxhv+X9WfwGF9qReMaEzuIe1nd8u2xW+ajNs1XTvSMRa8LZfsuUfk9
         GKqHAJz34nZzjifI+x0G6B+WotvRcYW10pA8fqDs=
Date:   Wed, 18 Mar 2020 12:42:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        ecree@solarflare.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 1/2] net: rename flow_action_hw_stats_types* ->
 flow_action_hw_stats*
Message-ID: <20200318124220.4fec8aa4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200318063356.GB11304@nanopsycho.orion>
References: <20200317014212.3467451-1-kuba@kernel.org>
        <20200317014212.3467451-2-kuba@kernel.org>
        <20200318063356.GB11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 07:33:56 +0100 Jiri Pirko wrote:
> >diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> >index efd8d47f6997..1e30b0d44b61 100644
> >--- a/include/net/flow_offload.h
> >+++ b/include/net/flow_offload.h
> >@@ -163,19 +163,17 @@ enum flow_action_mangle_base {
> > };
> > 
> > enum flow_action_hw_stats_type_bit {  
> 
> You should rename this enum.
> 
> 
> >-	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE_BIT,
> >-	FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT,
> >+	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
> >+	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> > };
> > 
> > enum flow_action_hw_stats_type {  
> 
> And this enum too.
> Also, while at it I think you should also rename the uapi and rest of
> the occurances to make things consistent.

Do you want me to rename the variables and struct members, too?

I thought in there the _type is fine, given how they are used.
