Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3FF41E55B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 02:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351401AbhJAAHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 20:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350508AbhJAAGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 20:06:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05C5461283;
        Fri,  1 Oct 2021 00:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633046708;
        bh=9Z0KbGZH64ADfJBv1OyGLnqkyE5ODF5dNMWDqrzOOpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iKKOZOPUO8zPMUx7gusGdSVSM0VdaA22zSNqGB9oui5XnQ5uX+tQdwyEMsujTneHd
         1zMN6Prmd/NQ87bKzTajxvXLH0Rkh1zxXXZTEUoA7jCtLfAfxWf1DEutkn4P5kSR17
         P+W3+jMSu6nSAaxkM42liXy8TOizWrbWOMTJPhdChMhuJkJ+j6K5xyko/eDo2GfKAb
         1CzYh4IwNCjM2K0azZokqSIgAN7jLROtQpMtWAqkNwFsDXdCvyH+zfh7NVRHKVLRVF
         /Oum7cIEWxPgQsxWVsNtcQnR0ontViGuHbJk6OK4wM7k6vj7iZWHFT4D54MUqb3/Iq
         d0o7PW2sUvcoA==
Date:   Thu, 30 Sep 2021 17:05:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [net-next] devlink: report maximum number of snapshots with
 regions
Message-ID: <20210930170506.24d74fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210930212104.1674017-1-jacob.e.keller@intel.com>
References: <20210930212104.1674017-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 14:21:04 -0700 Jacob Keller wrote:
> Each region has an independently configurable number of maximum
> snapshots. This information is not reported to userspace, making it not
> very discoverable. Fix this by adding a new
> DEVLINK_ATTR_REGION_MAX_SNAPSHOST attribute which is used to report this
> maximum.
> 
> Ex:
> 
>   $devlink region
>   pci/0000:af:00.0/nvm-flash: size 10485760 snapshot [] max 1
>   pci/0000:af:00.0/device-caps: size 4096 snapshot [] max 10
>   pci/0000:af:00.1/nvm-flash: size 10485760 snapshot [] max 1
>   pci/0000:af:00.1/device-caps: size 4096 snapshot [] max 10
> 
> This information enables users to understand why a new region command
> may fail due to having too many existing snapshots.
> 
> Reported-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
