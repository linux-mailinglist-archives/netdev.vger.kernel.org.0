Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1AB42ABFA
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhJLSeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhJLSeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:34:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A906460C40;
        Tue, 12 Oct 2021 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634063525;
        bh=UG5e9KMdmAA+6gd0oauTqSj9xn5H0HDLko5zPmXWyWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CCSrJttlgULGKcWs8m7qKkgOw0y6QwHUbkuCH9wFsKopIU1hLhcvfpCgU++obeD+7
         UYFG1JdrE2H32eylqQksEXwfDe/F1CL/TzU6jYuJDc9rNk9EvBwJE3hrXsnIbFkCBE
         17tKLyev1hqVV05ERTiojJgY95U/3z1hdvwYUmlV4CdDgXOoIgdJEtRk4EDv0wCvrw
         VwxvCZo+CoIIHPdcXI89CISImdtMpivKedIwbgRldDSS9sU4vntioo8ewsZNuuCkQy
         ZQ9RuCMcwYNtVSVGNBExzQu9Gl6yGAAqyUJrWUFyDDlAIlYchem05XK8vSVwfmQf+I
         EiPw5tO7y7hWg==
Date:   Tue, 12 Oct 2021 11:32:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Raju.Rangoju@amd.com, Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: Re: [PATCH v2 1/2] net: amd-xgbe: Toggle PLL settings during rate
 change
Message-ID: <20211012113204.66daca5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <62eca0fd-3aa0-395e-5309-f33dc3e0c55a@amd.com>
References: <20211012180415.3454346-1-Shyam-sundar.S-k@amd.com>
        <62eca0fd-3aa0-395e-5309-f33dc3e0c55a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 13:13:21 -0500 Tom Lendacky wrote:
> On 10/12/21 1:04 PM, Shyam Sundar S K wrote:
> > For each rate change command submission, the FW has to do phy
> > power off sequence internally. For this to happen correctly, the
> > PLL re-initialization control setting has to be turned off before
> > sending mailbox commands and re-enabled once the command submission
> > is complete.
> > 
> > Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> > Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>  
> 
> With the minor change below...

For both patches - any more info on the impact?

Will the link not come up? Driver lock up? ..?

It's unclear whether this is a fix for an issue which was always there,
new FW/HW/platform.

Please include information which will allow us to answer those
questions in the commit messages or cover letter for the series.

If it's a fix it will need Fixes tags (seems likely, even if it's a new
FW that surfaced the issue we probably still want the change to go to
stable.)

Thanks!
