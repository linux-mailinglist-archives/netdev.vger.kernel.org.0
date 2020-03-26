Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FADA194A61
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgCZVTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:19:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35646 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgCZVTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:19:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id m3so9477189wmi.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cDly14BZBgjm+cTjsvUHstMpnfFq2RASEAFrZXdxcyk=;
        b=PikVlIranVdZTEOC02PPlWK/5W/Hx5IH8FZTl29P5GnCk9btHZbUe/INLqSv+pE2sB
         7TIBkefAQ9ZiNTg0S0v7by57nJRM/OyU3HMt+Zrlj13rk8ZdsXhJSd5I5efvhyuMW3PA
         GcpFJHCH8p7uIBlYpHTZgQg+wG5qZv2ib625h3mQEzVry/U1xgpuwPXM/bupr+vqqbT2
         Dhwm7hMVg8z3Gp2u00YLWfDsQrrXk4A8Je9FqCzy8j8jnzNFz6C813EccT4oGePtY0G+
         OnvX0Y27m1JKrxvXB9Sc0vwShXpKh6CWbrEK7tKfp2ZqVuofTV8Yq4+qGRhPVoLxJpn/
         VwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cDly14BZBgjm+cTjsvUHstMpnfFq2RASEAFrZXdxcyk=;
        b=SWvPM4vfn929w3jFfojH7pyevLRst5AhjbqxfUtdAgemycmn9AZQxgnxrM7JZjSTv5
         H+LWw/NQWnKLQLzllokvefX8y1+WGXWBBPTT3kwsTFIgXweLgNKhvIdZ3v/3x1J0XSY5
         kpmhzScRQFomIxGWZTAxERVI9eCvxq49TuE95gvvTjp+4gcLubeEKWn7q8qzZb7NRaJw
         2MSpELlHel4I9qbr2qBKhQ7gh8eaQKhnrWS6d4Yg8PwRuQUD0ExdppA7X1cLHPOOs5C2
         JFhhyGAWCDS9hP2NXSuj/6uEFrvml/h3YzDTh5c0snEe16re6m7jFwfxoW7ohJzTGLat
         qfpw==
X-Gm-Message-State: ANhLgQ3BNqsrfLMFRG/fanQmyMVsshWMagF5/uWbR57X+HF3UdfoplFm
        3Pj39m/Hr8Kdh2oRbn4tL4ZNpw==
X-Google-Smtp-Source: ADFU+vtJG2e+AIFc49ZHyMm+k9h61isZIeGfwc6cVfq39i3ThSdc0mqyXXy1F+VVEeR1erDrZYXskg==
X-Received: by 2002:a7b:ca4e:: with SMTP id m14mr1875795wml.164.1585257549656;
        Thu, 26 Mar 2020 14:19:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z129sm5271313wmb.7.2020.03.26.14.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:19:09 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:19:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 11/11] ice: add a devlink region for dumping
 NVM contents
Message-ID: <20200326211908.GG11304@nanopsycho.orion>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-12-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326183718.2384349-12-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 07:37:18PM CET, jacob.e.keller@intel.com wrote:
>Add a devlink region for exposing the device's Non Volatime Memory flash
>contents.
>
>Support the recently added .snapshot operation, enabling userspace to
>request a snapshot of the NVM contents via DEVLINK_CMD_REGION_NEW.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
>Changes since RFC:
>* Capture the entire NVM instead of just Shadow RAM
>* Use vmalloc instead of kmalloc, since the memory does not need to be
>  physically contiguous.
>* Remove the direct reading function, as this will be sent in a separate
>  series
>
>Changes since v1:
>* use dev_err instead of dev_warn when a region fails to be created
>
>Changes since v2:
>* Removed redundant "out of memory" extack message
>* Fixed up function declaration alignment to avoid checkpatch.pl warnings
>
> Documentation/networking/devlink/ice.rst     | 26 ++++++
> drivers/net/ethernet/intel/ice/ice.h         |  2 +
> drivers/net/ethernet/intel/ice/ice_devlink.c | 96 ++++++++++++++++++++
> drivers/net/ethernet/intel/ice/ice_devlink.h |  3 +
> drivers/net/ethernet/intel/ice/ice_main.c    |  4 +
> 5 files changed, 131 insertions(+)
>
>diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
>index 37fbbd40a5e5..f3d6a3b50342 100644
>--- a/Documentation/networking/devlink/ice.rst
>+++ b/Documentation/networking/devlink/ice.rst
>@@ -69,3 +69,29 @@ The ``ice`` driver reports the following versions
>       - The version of the DDP package that is active in the device. Note
>         that both the name (as reported by ``fw.app.name``) and version are
>         required to uniquely identify the package.
>+
>+Regions
>+=======
>+
>+The ``ice`` driver enables access to the contents of the Non Volatile Memory
>+flash chip via the ``nvm-flash`` region.
>+
>+Users can request an immediate capture of a snapshot via the
>+``DEVLINK_CMD_REGION_NEW``
>+
>+.. code:: shell
>+
>+    $ devlink region new pci/0000:01:00.0/nvm-flash snapshot 1
>+    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>+
>+    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
>+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
>+    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
>+    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
>+
>+    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0
>+        length 16

I still think this should be one line. Anyway,

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
