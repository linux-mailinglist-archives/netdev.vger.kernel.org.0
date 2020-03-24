Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18EE190537
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgCXFdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:33:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgCXFdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 01:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=EAPcl74ab/jhGYJyIHynqPNANGgXmZYdDhLdbmdpCgo=; b=qhzPsFlVHFsqMBJcNYvh1JOHhB
        9kM3XghwWJTnSQ4K1f2OGpW12+GHxO11Acw/nITbB7IyzBejllTZLE7UFyXrjI1PoCwCSnMuwS84u
        iSxhztwdiS74SCNAG0w2gMJOzLn6/e8z0KehR3FWmsdKj3W7eW5pGOkjyBL2zEFCwj0wjBv26fjDj
        6aF8j2J17yBezv5S613b3ZdQgJCf/bPtTbKoOdKSlA42xqzS/IXF5N80cDf6kEGdI16OshfAXh4pC
        eO7n8yKbfcBP0AIk0843OAqo19mgX9DRC+MtfEQ7Z6LGBeb7Ri/GrGgYWDHaMaiE+Pd79CldzCu7i
        en4w19ig==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGcBr-00046O-Ki; Tue, 24 Mar 2020 05:33:27 +0000
Subject: Re: [PATCH net-next v2] devlink: expand the devlink-info
 documentation
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, eugenem@fb.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        michael.chan@broadcom.com, snelson@pensando.io,
        jesse.brandeburg@intel.com, vasundhara-v.volam@broadcom.com
References: <20200324041548.87488-1-kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fa91cf18-8d2c-bc11-b3d3-bd8671318e7f@infradead.org>
Date:   Mon, 23 Mar 2020 22:33:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324041548.87488-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/20 9:15 PM, Jakub Kicinski wrote:
> We are having multiple review cycles with all vendors trying
> to implement devlink-info. Let's expand the documentation with
> more information about what's implemented and motivation behind
> this interface in an attempt to make the implementations easier.
> 
> Describe what each info section is supposed to contain, and make
> some references to other HW interfaces (PCI caps).
> 
> Document how firmware management is expected to look, to make
> it clear how devlink-info and devlink-flash work in concert.
> 
> Name some future work.
> 
> v2: - improve wording
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Hi Jakub,

One minor edit below, and

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  .../networking/devlink/devlink-flash.rst      |  93 ++++++++++++
>  .../networking/devlink/devlink-info.rst       | 133 +++++++++++++++---
>  .../networking/devlink/devlink-params.rst     |   2 +
>  Documentation/networking/devlink/index.rst    |   1 +
>  4 files changed, 213 insertions(+), 16 deletions(-)
>  create mode 100644 Documentation/networking/devlink/devlink-flash.rst
> 


> diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> index 70981dd1b981..8d47289a5844 100644
> --- a/Documentation/networking/devlink/devlink-info.rst
> +++ b/Documentation/networking/devlink/devlink-info.rst
> @@ -5,34 +5,119 @@ Devlink Info

[snip]

>  Generic Versions
>  ================
>  
>  It is expected that drivers use the following generic names for exporting
> -version information. Other information may be exposed using driver-specific
> -names, but these should be documented in the driver-specific file.
> +version information. If a generic name for a given component doesn't exist, yet,

                                                                        exist yet,

> +driver authors should consult existing driver-specific versions and attempt
> +reuse. As last resort, if a component is truly unique, using driver-specific
> +names is allowed, but these should be documented in the driver-specific file.
> +
> +All versions should try to use the following terminology:


cheers.
-- 
~Randy

