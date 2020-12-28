Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8DD2E6C24
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgL1Wzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbgL1WIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:08:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E31722242;
        Mon, 28 Dec 2020 22:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609193256;
        bh=jxMBIklvgaQLCmJiJ84OK55WKAZYsAer1pBEuopHV5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qh8QE7E2JZurGrskqYbA/3bUs5W5yeYZj6l4P/N9kzd6YH3db5xLTXaRs3ZGzNbp4
         lFPOm29jqP+olQL5cSFvmQcJqmBSu5sy+aesAXhb10AtNI7ypCkyMe5iBzOXkcIbnP
         2OFs2s7mFISIEzOQ0ZfKScaT/WoJWOPp6X4kYWiN8mz3BwfJRkfd0+cxgid4DjlkLt
         56e3POb4/HMYu8s6JBxV2nATlIdZOGYa3SBXqKCRNIzK+t3rdvhnt3AY9gtm5MErMl
         aKkSu72CF8jwqs4LPNV+NYHNohJwmN+4womwoy+MwTws1BnlCx3OeNmC+EMUyYs1qd
         vXmTe2havsINg==
Date:   Mon, 28 Dec 2020 14:07:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        alexander.duyck@gmail.com, sasha.neftin@intel.com,
        darcari@redhat.com, Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com, hdegoede@redhat.com,
        mario.limonciello@dell.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-12-23
Message-ID: <20201228140735.4949e592@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223233625.92519-1-anthony.l.nguyen@intel.com>
References: <20201223233625.92519-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 15:36:21 -0800 Tony Nguyen wrote:
> Commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
> systems") disabled S0ix flows for systems that have various incarnations of
> the i219-LM ethernet controller.  This was done because of some regressions
> caused by an earlier commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for
> cable connected case") with i219-LM controller.
> 
> Per discussion with Intel architecture team this direction should be
> changed and allow S0ix flows to be used by default.  This patch series
> includes directional changes for their conclusions in
> https://lkml.org/lkml/2020/12/13/15.

Pulled, thanks!
