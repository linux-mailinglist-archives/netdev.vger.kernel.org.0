Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F9961DC8
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 13:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfGHL3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 07:29:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36627 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730225AbfGHL3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 07:29:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so16685051wrs.3
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 04:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HGNoIO92XfU6BmjuZO8ZcP7puW9Oo2FIlAYY2neFLYI=;
        b=MDoniH5KY+4VzpEkjcLecoHcPsLrS7IZDyFfK4b8jNIN5CnAysuDsIwptsmyni5Jlp
         7XtSmQ/1tGA6dURY0otOhMPEz7umCleNrGPSq1U8WtS0KGwrfeWM7OigmjEaIlQmk6sL
         w/Mqalp5HMztd/TCHdBeiRPNA7hYOEb1NAd/EzQikT5GantQSfs57vXmVMM7oJvsGY01
         nJmexVzkbOFc3Qa2++z7F0ijJUS1OR9zcVdWonTZTx5oSSEcT86mvEe03LX2fPsUHjAl
         wosCf0p4q9lKSzeEJalxYz1N08OqRboTd7HIL4QwtCc1vLdn0XzQXrGRlFzbchwjsXmt
         UWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HGNoIO92XfU6BmjuZO8ZcP7puW9Oo2FIlAYY2neFLYI=;
        b=YdRShKJEVkZ9hHMuSJWPULiiBf5aR5RIDHzflCFS5mCQR5gILSjUzYB5rveg/mMTEm
         1TwsmjsTXzUwRfPcBW5OYLrcUIkUext7LYUupSJkDywUaU3IenVhkQ3HPevfWt53mo65
         HE2qNBVLvP5Zqdg8NQHTca3j3G1/pyVal3m+qXPCPvB/rrnZGMfbToRcVYpQK9vPUzQj
         iQehaZHhIJfth02a6xneeOQL86AOn2im1M8Gy4IZV+uoeZ35AAXe8eKpxZL7T6p+I/8S
         VPVE5yJDKTgWEVfyvdLtI7UFiD9SeXIrMDwmIZr95mshHz6cTEf5GTRj/JM3A4NFMG1p
         SXHg==
X-Gm-Message-State: APjAAAVVDnGcnRBUIKVTDPOWExOZ8G77ZfchT5UvLY5909Mz8MtU/qoA
        o823rPXmxtFRXGcz+N9yz9J16vRHQlQ=
X-Google-Smtp-Source: APXvYqyVQlpK/cF3uf2Mkxu0CWvPKud8z5tJRgOBZk9g/XXOfU6SwN3s8uwRz144SbNJTf1ZJoBOUw==
X-Received: by 2002:adf:dcc6:: with SMTP id x6mr18721836wrm.322.1562585383145;
        Mon, 08 Jul 2019 04:29:43 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id t6sm18531106wmb.29.2019.07.08.04.29.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 04:29:42 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:29:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 06/16] net/mlx5e: Change naming convention for
 reporter's functions
Message-ID: <20190708112940.GD2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-7-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-7-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:52:58PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Change from mlx5e_tx_reporter_* to mlx5e_reporter_tx_*. In the following
>patches in the set rx reporter is added, the new naming convention is
>more uniformed.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
