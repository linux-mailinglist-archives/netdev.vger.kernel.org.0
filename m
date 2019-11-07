Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1448CF2CC2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbfKGKqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:46:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36853 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKGKqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:46:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id r10so2470342wrx.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 02:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nDQQccSHhJfL7vRd2Ya4dHqYi0017dX75meuR3WGMbw=;
        b=hQn7H9LLfEPPjTN6/eCjuCuPCeD81xFZrbCRQ7IhL9trUJTKKG249hx5p76gMGATSN
         rA5REE3Ha1vGjVkLJZmNj7G0aELcGLHG5j8kaEFIkktYKmgF3rYiP3JaL4GCnqfH3TWA
         OEBIzu0rBv7BTL4vtGVRaytaJE0r+G15X8tre/1R14c6beLUGnHEx1uRz6vG1RXMalvn
         BzY6JuXLRGBw3EBx43dg/B6rkqDl+aQ6Vajy4WvG6gPsubgsBRBeftivTxV1QiH9jvEu
         WV+RHj7YEn4R1qs7//Zqxhs1efBppdZpd8LsWA4nhcqnwaal+V9zTSCYn7dnBzOmBmX2
         fL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nDQQccSHhJfL7vRd2Ya4dHqYi0017dX75meuR3WGMbw=;
        b=Ic0hQRMiA2KvgFA6W1dlwqvdphl+nLA6zyEWp2jovGPfZtG9fJ75JUoubq6ThBVqme
         Mhuwxu9yxi521Pefu72sUNFB/MIexxwmIHGvDi/SBWgxJgTuKwWHF7/OnflTIREHUKnY
         n36eDeLAb6i4WU/ZnoXZDVXODUXhL1ASlTf4mBsKlldL38qTWBspaZHu42P3OJeHlX0Z
         fLn62QDxJzfJYcQY6l08xpX07FhoKiF8B+u15eMC3D9PX3rIM3a7q8MSnMZ0wRSdaYMe
         F2Oz397ihzxvjO/HTzN6w5deiqDDt43Lx1NSRDBTIINlmsDcS5mxD4b+Bff6G4W5+UHt
         MlaQ==
X-Gm-Message-State: APjAAAUK05E+aqOEaCNQtb9xFN5UEAY+9GvPDTq8M9icENyEwFJyanPa
        5K6StFpiiNRXvszHhVkYNCiYKg==
X-Google-Smtp-Source: APXvYqyPqa6XTb9KKoMaHreHNMrYQp9C47IfASP6ga2dQK7Xw/sFxq4blMu2qX8HwsgcDkAMDyAHtw==
X-Received: by 2002:adf:f452:: with SMTP id f18mr2290517wrp.264.1573123594583;
        Thu, 07 Nov 2019 02:46:34 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id a6sm1416495wmj.1.2019.11.07.02.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 02:46:34 -0800 (PST)
Date:   Thu, 7 Nov 2019 11:46:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: spectrum: Fix error return code in
 mlxsw_sp_port_module_info_init()
Message-ID: <20191107104633.GD2200@nanopsycho>
References: <20191106145231.39128-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106145231.39128-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 06, 2019 at 03:52:31PM CET, weiyongjun1@huawei.com wrote:
>Fix to return negative error code -ENOMEM from the error handling
>case instead of 0, as done elsewhere in this function.
>
>Fixes: 4a7f970f1240 ("mlxsw: spectrum: Replace port_to_module array with array of structs")
>Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
