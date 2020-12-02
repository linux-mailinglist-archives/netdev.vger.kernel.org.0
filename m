Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC72CC465
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgLBR5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLBR5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 12:57:15 -0500
Date:   Wed, 2 Dec 2020 09:56:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606931795;
        bh=vmLn/MlDGaCd8fhIKRd2EQZ9afZZQcjjry1uoQfX0p8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GioZlypz3oyAqeNgtXYfIttZJBQ4kJHJ2Oks/1C5VEf1MeRYXSEGZPv6IGErQhjMD
         cYM0r/5LQTlxbjuYlaTdnxY2scwpxnjPYAEfpIer/hfpEPN4LYyRZbcZTPha/95rNH
         CitRDmHlt4bcha2ldYlQ3HzpCRsKign04R3BQBYk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org
Subject: Re: [net:master 1/3] ERROR: modpost: "__uio_register_device"
 undefined!
Message-ID: <20201202095633.25a29431@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <yq11rg8cczn.fsf@ca-mkp.ca.oracle.com>
References: <202012021229.9PwxJvFJ-lkp@intel.com>
        <8875896f-81a7-cbda-3b6e-97b5b22383c3@infradead.org>
        <20201202094624.32a959fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <yq11rg8cczn.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Dec 2020 12:52:20 -0500 Martin K. Petersen wrote:
> Jakub,
> 
> > Martin is it an option to drop the patch from scsi-staging and put it
> > in the queue for 5.10 (yours or ours)?  
> 
> I'll shuffle it over to my fixes branch.

Great, thank you!
