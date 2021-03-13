Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E95339A5D
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 01:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhCMAPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 19:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhCMAPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 19:15:25 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38086C061574;
        Fri, 12 Mar 2021 16:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=JePAABAPEzeiHP1VoB7WiI6tyL6YPM6YydNu+rZ3DfA=; b=Sm7cWYFcbFbZn4MViXN9teemZn
        iL/BWIy6dckaRLZ/UiD/ilAQybzSYq++tZolAQ0G4GMaCsYAbrytvTbBsTNuNI8joAEyFgn3CVWpX
        H8eNppTnOYzv9BncDHHLZ1hL7AWhMh/JEbLT3Kybs4bcpagC+0apWOrcW2KM63WKkiaHuHJUZ7JrX
        8wrHlWqIRvzQyI/sN/JNoPPuAMGkD20v6j4fX0fVhgVQICVkwxnBJKOUFS1VbSUNYLoA6WocPTT3i
        4vrZbNF0iigacdH2hhP+ak5wIi+XrbXxgp5G9+sbj15ThWRP8wFw29M1e1TZ+v0wHPNIOEWuW8C10
        xy5/udLQ==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKrw9-0016Mj-TS; Sat, 13 Mar 2021 00:15:22 +0000
Subject: Re: [PATCH] devlink: fix typo in documentation
To:     Eva Dengler <eva.dengler@fau.de>, linux-doc@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
References: <20210313000413.138212-1-eva.dengler@fau.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9a768353-8068-427e-1c13-39798fc646e6@infradead.org>
Date:   Fri, 12 Mar 2021 16:15:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210313000413.138212-1-eva.dengler@fau.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 4:04 PM, Eva Dengler wrote:
> This commit fixes three spelling typos in devlink-dpipe.rst and
> devlink-port.rst.
> 
> Signed-off-by: Eva Dengler <eva.dengler@fau.de>

LGTM.
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  Documentation/networking/devlink/devlink-dpipe.rst | 2 +-
>  Documentation/networking/devlink/devlink-port.rst  | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/networking/devlink/devlink-dpipe.rst b/Documentation/networking/devlink/devlink-dpipe.rst
> index 468fe1001b74..af37f250df43 100644
> --- a/Documentation/networking/devlink/devlink-dpipe.rst
> +++ b/Documentation/networking/devlink/devlink-dpipe.rst
> @@ -52,7 +52,7 @@ purposes as a standard complementary tool. The system's view from
>  ``devlink-dpipe`` should change according to the changes done by the
>  standard configuration tools.
>  
> -For example, it’s quiet common to  implement Access Control Lists (ACL)
> +For example, it’s quite common to  implement Access Control Lists (ACL)
>  using Ternary Content Addressable Memory (TCAM). The TCAM memory can be
>  divided into TCAM regions. Complex TC filters can have multiple rules with
>  different priorities and different lookup keys. On the other hand hardware
> diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
> index e99b41599465..ab790e7980b8 100644
> --- a/Documentation/networking/devlink/devlink-port.rst
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -151,7 +151,7 @@ representor netdevice.
>  -------------
>  A subfunction devlink port is created but it is not active yet. That means the
>  entities are created on devlink side, the e-switch port representor is created,
> -but the subfunction device itself it not created. A user might use e-switch port
> +but the subfunction device itself is not created. A user might use e-switch port
>  representor to do settings, putting it into bridge, adding TC rules, etc. A user
>  might as well configure the hardware address (such as MAC address) of the
>  subfunction while subfunction is inactive.
> @@ -173,7 +173,7 @@ Terms and Definitions
>     * - Term
>       - Definitions
>     * - ``PCI device``
> -     - A physical PCI device having one or more PCI bus consists of one or
> +     - A physical PCI device having one or more PCI buses consists of one or
>         more PCI controllers.
>     * - ``PCI controller``
>       -  A controller consists of potentially multiple physical functions,
> 


-- 
~Randy

