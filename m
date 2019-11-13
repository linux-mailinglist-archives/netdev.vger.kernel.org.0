Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E8FB15E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 14:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfKMNdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 08:33:41 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35848 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKMNdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 08:33:41 -0500
Received: by mail-ot1-f68.google.com with SMTP id f10so1607630oto.3;
        Wed, 13 Nov 2019 05:33:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JMGlC8/pif+jB1W9f7yADN5pub681PWuOZ+nengKGCU=;
        b=Qr0ycIfWrnd1ks/W+lyYxxeqoxdTAsyK0QGm91lIBqgDFIbGyxBQUKLkJokB7kqv2i
         74KkIUk5XJzWE0oYa3zhXx7HsFwVnimXSfJOsWUWTqx4naxfqSh20v9giThqoPXIazPx
         nHSYi00nQ5/xRc15KUxC3BgGbrM/vDZuCXf0uwTk3tTCU9bA1lLjlFRWZWOBpD4g75cR
         JYMegTN1CcOc8euP4zINJtxhM9TpJae+HG3FU/dyqR4Wxx5fbBkRjfmLV2wsV3+E0NUp
         ZOcQiRizXOU17R+97u9QOMAv1Tk8IceLGCbCfc/FPTHrMfeU2CyM2Xqi1b3g3NRRlel/
         K0XQ==
X-Gm-Message-State: APjAAAXTnC4iCD++3kzuOt7FlHZQN6fVf5SgHzUS5KzWjT8RwJBcyHrL
        K4LKe7Puokel2bTljoTxtg==
X-Google-Smtp-Source: APXvYqxD6IWsewO9TdJ3bFTU+gY51WG3vNByXca8SVZxroh1OIj61piRW22xnKzAJ5FMxoSywmWh5A==
X-Received: by 2002:a05:6830:1f4b:: with SMTP id u11mr2802561oth.60.1573652018588;
        Wed, 13 Nov 2019 05:33:38 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u204sm685118oig.35.2019.11.13.05.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 05:33:37 -0800 (PST)
Date:   Wed, 13 Nov 2019 07:33:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        devicetree@vger.kernel.org, letux-kernel@openphoenux.org,
        linux-mmc@vger.kernel.org, kernel@pyra-handheld.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 01/12] Documentation: dt: wireless: update wl1251 for
 sdio
Message-ID: <20191113133337.GA3987@bogus>
References: <cover.1573122644.git.hns@goldelico.com>
 <17b12e91c878dcb74160e3df5f88bc8a9e3f7fce.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17b12e91c878dcb74160e3df5f88bc8a9e3f7fce.1573122644.git.hns@goldelico.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 11:30:34 +0100, "H. Nikolaus Schaller" wrote:
> The standard method for sdio devices connected to
> an sdio interface is to define them as a child node
> like we can see with wlcore.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  .../bindings/net/wireless/ti,wl1251.txt       | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
