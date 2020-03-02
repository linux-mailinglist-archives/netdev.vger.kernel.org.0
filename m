Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B313B176151
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCBRmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:42:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36644 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgCBRmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 12:42:09 -0500
Received: by mail-wr1-f67.google.com with SMTP id j16so851465wrt.3
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 09:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hk+o2f7qmnaTtrXjIIRTww8Sa3hFt080g2qUI40zg2I=;
        b=R9edmTSuoII+fbR71F28206U1VMwO8M7cWE0o0natSwU8CHJPo/BXANLe6EgEhD5Or
         kLmPTQSTW+ghbHiE5gd+mFhBHKjh1/l+qS85MRvqoWzLA5WT+zGhbZRIdU0PG5ItIOyg
         1C7peymRrpSoQ4WCbHiGa+hBHtR7M9NUWj0nMCLUDv2Fys0Vnd2oByIG5VtW1rMFSBkC
         use8rP43puUHB9FO5Z3mmK8da2jBi/zZ0sWKXQ04qAb8WMVDwqIOtXsVs9M+GdbAHFcc
         S4OD+qb0H2WRYV5UkysLWDfpy1SvM2BRPMm8rVxbSbvYQ8sbgCRPnsu9crRxq2pkFwNB
         9aIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hk+o2f7qmnaTtrXjIIRTww8Sa3hFt080g2qUI40zg2I=;
        b=AL3EIj9iGEdWLnOsj9TBlkExBU5iDI6T9Gz4XhaUZaKj+/pTK4yjEeCeUGfyVKXtw9
         I1Y454ptkz7HVwZQOY/cwqhvuMvZE95VGKU/mB7F3a0j+QSsWe9Re1Bg8CvDjvZYrI++
         FcwhuBIvgfQdAqGAejJ4QcsJZOsXPykXSmflB9Oxa4T0jxxvsKdbFCV9Ggs0cba1hk+2
         jtHBaBnN2GufhNKCoaHI8woWqba/I0P0V0FxTA7FjRNWB+E6LV+Kb3QREguYC3996hbq
         j01j5iJrZhDU/ah0Rexo7fYK6Zesz1wyXYa2s/CBDqLLAZUxgZiwRxd8RumwEW4kTfJa
         0lcQ==
X-Gm-Message-State: ANhLgQ246eE84midI5aSfg7cJTKglmK9bKGTlSTocl7kt8uKoBTCoxyU
        13nECzi/HPpsWO9Vc7XJXbowIw==
X-Google-Smtp-Source: ADFU+vs9CccVPjicGxi0sWAkesgp3VfkOecea5tqkvm/mHLD1dPtfOJmGBNOiZ1F78oXKCJeLHJVgA==
X-Received: by 2002:a5d:4450:: with SMTP id x16mr672857wrr.242.1583170928140;
        Mon, 02 Mar 2020 09:42:08 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id o16sm14245569wrj.5.2020.03.02.09.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:42:07 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:42:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 08/22] devlink: prepare to support region
 operations
Message-ID: <20200302174205.GD2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-9-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-9-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:22:07AM CET, jacob.e.keller@intel.com wrote:
>Modify the devlink region code in preparation for adding new operations
>on regions.
>
>Create a devlink_region_ops structure, and move the name pointer from
>within the devlink_region structure into the ops structure (similar to
>the devlink_health_reporter_ops).
>
>This prepares the regions to enable support of additional operations in
>the future such as requesting snapshots, or accessing the region
>directly without a snapshot.
>
>In order to re-use the constant strings in the mlx4 driver their
>declaration must be changed to 'const char * const' to ensure the
>compiler realizes that both the data and the pointer cannot change.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
