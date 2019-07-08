Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9209361EB1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfGHMn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:43:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39223 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGHMn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:43:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so16929388wrt.6
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 05:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KiFKXnsw35cJhRU1HfiX45r7hJn4aM30316XTobK8W4=;
        b=FYqxhELL5eIljiwK/DzaH7UvmnIhEC6YawEJt1vEv1CBHIpK5g5FblngpERB59j9wQ
         Wa1Pg2JxA5axBD2H6xMEyfTyCZqjDen02Ru0YPjKIVeJCnhFdptZ+oO69j/k5ipcQIpL
         RQYwxnyNRPSRsXV7OygUCJNf98SoJQI6Jw+yOYVsYKlYNjAmxeG3WN3JG27Kjws4VFSu
         inDP3o2LkU2Z+tozRfN5SBT/q2Sd44B4ZGQilGO8koviEZ9sZinZSNQ7crRvHpU9SZs0
         6mSmkwQ2reMnPvd73YPSqW/cGulNkHt3rRjucPx5RWbEEcB2F6NRIrGYO6kJDbhThvTk
         ctpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KiFKXnsw35cJhRU1HfiX45r7hJn4aM30316XTobK8W4=;
        b=IP62M+HOhByW8qbuaTxo6a8usmWkgl28oa5JJ/bFPnt438u/Qy29ocz4M2XDPZL/ti
         slgrAe8e4HVeYvPS50AxJE+w4iuUmPfVphtytsW/qYID1L/k7vQcuJF09PP5Zis2EymQ
         epfbq7JWlxMNBNoeA5KUJNxe4ZgZXGPwDiVatbsyHgJfzDCN2l/1EnrJhayuaW0DGgZ4
         w5sZU8xM5zozTbvJ+szQyjaA6QR7cHDPU75YHQG8hyIrYeMjZkkQx3EripVbo4cDT7FU
         Zn1axkqX7RDjJhTfLVscoSMPbDwvdaTbjrjLLdpN7W4Q/dp+QjqJRY7Ww3PycoSBwc7i
         vQIg==
X-Gm-Message-State: APjAAAV3cDy2HpLyBD9PGpwSNNIbrO+OkoMY0O0WXXXS5WtbKzsZvZTp
        pAzVECWGa0TIMRtgjEmiFpzu6w==
X-Google-Smtp-Source: APXvYqyRIrO+4ziMW93XeGm2sYDPz5rOmwxPFlleuWcSLtmXQGp2qFlrgdZGHTNpI/bp3zlBaSrtcw==
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr18284565wrj.272.1562589834969;
        Mon, 08 Jul 2019 05:43:54 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id c14sm12878729wrr.56.2019.07.08.05.43.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 05:43:54 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:43:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 08/16] net/mlx5e: Extend tx diagnose function
Message-ID: <20190708124353.GF2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-9-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-9-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:00PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>The following patches in the set enhance the diagnostics info of tx
>reporter. Therefore, it is better to pass a pointer to the SQ for
>further data extraction.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
