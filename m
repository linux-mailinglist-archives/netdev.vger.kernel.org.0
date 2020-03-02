Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928EE176153
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgCBRmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:42:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37621 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgCBRmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 12:42:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id q8so840377wrm.4
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 09:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7XS3bB5j1TxPsUv4AZThxEdj83l/rIEJsFJFwZlNeXM=;
        b=mHkvcuUPe6jWhL0vsGh32y3CUSFN5p8Fihk1UQaP9hPhD9DQHzqt2mhRlu6eVogUhu
         neipwDt8nKcvsSjGIUQeFK4E+L1UZBlRV9inIkBcnHIe0R0ttbbUN7WoHd63dq2gKDwF
         ZX7Aozx0nxeMKTWQeoICzcP9/TSKhSrq3s8WfaDhJPG66O+0bc4PgGAS5K+QG25NoiL1
         +SpbbvpC/b128oNzUJpm2IODz7qhAThhkKWnLQper+c24YJzGm5idSsSG0GNid6WgVOD
         PzTt9bjPBGxzFSe+qt3wDRkgyVlDCBult9lo60u1ptLQwFb+t2OoVTwHqliqm5ljpu5p
         WGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7XS3bB5j1TxPsUv4AZThxEdj83l/rIEJsFJFwZlNeXM=;
        b=tzJDc3SIS/AVQod5P0TGUVm41Q5cSKZVbTXtEXDY9Kfeg2VzxnIxeUzSptCSRQm49Z
         c/ivCK2lYxvkA6L2ysWghZ2cemwP2gzxxUL5jBsnDruX2IFQOSiYZLqAEmakhQmm/nlk
         OumF4CBjkWBOLn869ZdunvR5viSpSUiGEOo09cxFN4FFegYCkezsxF7fDSrG8WS34DSP
         hVcauuZ7ft+vxSQBLJRAVE1At/skjS4FiheSi/QdcxpgyQ9YckZvxIq7xCFiVIo+pRNR
         bzabrqafoPfTCPNlmUCVczKnqIOonIfulPXAKmIYwZbE7zpBD0K8ILjGm7Xd1HhwHkiX
         F1NQ==
X-Gm-Message-State: ANhLgQ1kIbyJrC1gTiwmvgXu589h34M9I1/isfaoGqfdrOzxs+VSE7y8
        eeIp7ptZU8ZvEC9egSetXXX6Vg==
X-Google-Smtp-Source: ADFU+vvQZW9AdGDp9TC2rHrJM5yZ6eXDunXJcNG6FzkkCR4MyAPemBmT5Iyda9JTbdJS9fkc+r+H0Q==
X-Received: by 2002:adf:dd8f:: with SMTP id x15mr685119wrl.284.1583170970300;
        Mon, 02 Mar 2020 09:42:50 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id 90sm28763563wro.79.2020.03.02.09.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:42:49 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:42:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 10/22] devlink: trivial: fix tab in function
 documentation
Message-ID: <20200302174248.GF2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-11-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-11-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:22:09AM CET, jacob.e.keller@intel.com wrote:
>The function documentation comment for devlink_region_snapshot_create
>included a literal tab character between 'future analyses' that was
>difficult to spot as it happened to only display as one space wide.
>
>Fix the comment to use a space here instead of a stray tab appearing in
>the middle of a sentence.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
