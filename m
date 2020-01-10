Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0956136A0F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 10:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgAJJgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 04:36:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42748 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgAJJgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 04:36:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so1100957wro.9
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 01:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Q9e6ia1B3GJb/96TdFkPsyoMjZj6xp/EaWt0ZKXYyY=;
        b=wh+AapZEoJcqSyWTcqbM4cZIzlZmq1lAAcD6NkdWs9gLwZgNBw77iG8LodULRc6CX1
         U5oVWLyZLgqya5ZcyIjVcATVh35F+d1t2qG54acrqlY3l1quKTaOyPaRRGF2BL01G9Sd
         DSQcngzYOPxHdRu4Z68tlIkO/Xb/oEpJjXVfFTpegw2ecWGzpzr/tZxUEJV56sBytBQX
         eBCYr4IXIZBaqjnoh8nOpnXrNrPXwo3i6tx4r32ceZKdooexI2xUCCti1Bui71LVflv7
         7WPjRJ9V4KjWx8J7I/u8GvrLjuUeCJxAA21zilZpxA2/3nWk25l6lLzmmClav9HP4IXs
         s0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Q9e6ia1B3GJb/96TdFkPsyoMjZj6xp/EaWt0ZKXYyY=;
        b=M/igUAEIHS8IYZv2YjILk1sA4YO3dyOgfqnfFDyVeZdjcKVW/4eMqqZgUB/q+mm3Zf
         vG3m0asmjNZNlEpqyP8SPm4sInyNVBrwpNsMiYH7UsoG28wJoB6DFSJEvw+9Rz+2OlnL
         zR1Vn0CotXnBknLKhFD5AKsj90mqaMW5dXIem9WRoUULoxOZh6kX5FVCc88Jn//LzTzu
         qc8ismo5jtRhcsVzIxkAFo5uzyYTs/ZluQ91zk7Scq611TNGpK9ZHostCnWkFnb1hO3G
         YLSKi9OvlDrD5d+RFApxxT5KTCwIrXYGYyApYSZCxPXtlKmZPNbwE6v4Ng0YQKyk1X0C
         7r5g==
X-Gm-Message-State: APjAAAW/PZxgrx1w1ASOMhqbOIiGJL+mLWm04V4UulERqvvOLon2xiRB
        THvxQIa2dpgkz8xMnDCN1pP5wA==
X-Google-Smtp-Source: APXvYqxUhxHIrT6FLY3YJ2BFMRc3QcoGhrvZhnXb9Wpn+WMsDTt/wUXz4czv+F4w/6mObY9IpBmxcg==
X-Received: by 2002:adf:9c8f:: with SMTP id d15mr2461555wre.390.1578648998003;
        Fri, 10 Jan 2020 01:36:38 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t190sm1517429wmt.44.2020.01.10.01.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 01:36:37 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:36:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com
Subject: Re: [PATCH 1/2] devlink: correct misspelling of snapshot
Message-ID: <20200110093636.GK2235@nanopsycho.orion>
References: <20200109190821.1335579-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109190821.1335579-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 09, 2020 at 08:08:20PM CET, jacob.e.keller@intel.com wrote:
>The function to obtain a unique snapshot id was mistakenly typo'd as
>devlink_region_shapshot_id_get. Fix this typo by renaming the function
>and all of its users.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

If you want to send this as a patchset, please provide a cover letter.

This patch looks fine to me.

Acked-by: Jiri Pirko <jiri@mellanox.com>
