Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88A6437F6D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhJVUpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232750AbhJVUpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 16:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0301C61040;
        Fri, 22 Oct 2021 20:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634935411;
        bh=QRjAV4o4+c8NfwPqd5WLPxIN0sMUZnkUhgzIjbrx0a4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=itkPhCtyunDKctXAy8m4YJbI9dZSlLgaLhH5MH5KxfVrVQsS1i+BKxb/mrt05j3da
         C6THCecgrvL0JGtyUZKmt3ENO/roDksF5YsKhhiJajXXkyi/WAvsh4Gv3Y+q5q0vNQ
         XRqpAQ2dEaP1YaaxPfYwjZVhul0nbbwYRzSR8k/hR2+MTaJEg6eNUoMpgfCxLOjGiY
         u+2pJYWdIk9HALuoFFjHw2I0n0MKRT3kMWRN+etuuAe7DyxUo7848MTIjogZ7F/2NK
         45d4Yk1Xcxbym/n55ok/zWDaMhDVdtB+viHYj53d4XdCaeD2YnXkvV6Y0SBqdUtOo3
         bpFSdFWkcADfg==
Date:   Fri, 22 Oct 2021 13:43:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com
Subject: Re: [PATCH 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2
 modem
Message-ID: <20211022134330.25ac88af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cdb9e908-b87f-cda9-5b5d-bd1eb250ba10@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
        <20211021152317.3de4d226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdb9e908-b87f-cda9-5b5d-bd1eb250ba10@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Oct 2021 13:20:38 -0700 Martinez, Ricardo wrote:
> On 10/21/2021 3:23 PM, Jakub Kicinski wrote:
> > On Thu, 21 Oct 2021 13:27:24 -0700 Ricardo Martinez wrote:  
> >> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution
> >> which is based on MediaTek's T700 modem to provide WWAN connectivity.  
> > 
> > It needs to build cleanly with W=1, and have no kdoc warnings
> > (scripts/kernel-doc -none).
> >   
> It builds cleanly with W=1, I test with 'make W=1 -C . M=drivers/net/wwan/t7xx'.
> Regarding kernel-doc, there's an enum that does need a documentation update.

Fetch the latest net-next/master, rebase and try again. 

Throw in sparse checking for good measure (C=1).
