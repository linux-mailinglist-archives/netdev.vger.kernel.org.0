Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28299D03FD
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfJHXSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:18:44 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45969 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJHXSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:18:44 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so638776qtj.12
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Chpzm2CGWYEU7BeQrY30guJw6lX8n1FnBSXHZjAIIUE=;
        b=T0st95jzZlooFdg5EgpFth6jQNe6V0tCsXwMjpdQKknL5E56P6UZFAoi8tocI9E2JQ
         7O6U4q/6vGIgK/jj28nDvI6nHV724o9cINuSUuuoItg/x0Fcz8BT6eu83BRw+Qp1Dskp
         MFTej31sNHMSEsd/LaQ2ylvNb1zXeJpZaeeOkUsjFVdrivO8v9gDIMbB4Ns2qZrw+VEq
         1N/Ua6YL1A5QK4pm/hJkVzzDeHh1s96vPj+gc9hDcWk8/IAsZM9JU1xj1v48pvuK+H8i
         +KuH79S80SubO9zxwgk8nuaET686gJSMqJTFtM2mvHOa3lSpaG3e3sXvCZWaKwXca6OZ
         FkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Chpzm2CGWYEU7BeQrY30guJw6lX8n1FnBSXHZjAIIUE=;
        b=V117j+Yz4mhow4c3mRBUeNNs0gyk0RL7V4n+vPhfx5gOYaQ/KK186GpyPu234xM3F9
         5md4upd+lpEq6AN5hIYxxqnXY4zzC7884w477h8d3CYmildhGK0E9IGdeCXvGtiba2o5
         5IM9qjQSRyNNVJKKEsD9WH/jB7rGpmJJ5yQD43HdL3phxUK6/+Wxp/fUHdinPrVQMkep
         7LNG7nRfYmyiE6NYxOUnC5kOweh+y18wXDovUFOPVhtW50NKTVEWiUhkX/sT+CuXOHiR
         nFeZ/6nakpKFhWWQ0begcFdt/7aKp5NDBDYqfub/dZck6wsoZ7OC8cMXMyELYhiuJTQP
         1wQw==
X-Gm-Message-State: APjAAAWFWY8FUREylmV9fIofG6TYvAmQWgTqYKSlJKeUFSMYk+AXDMzc
        GED81q/+ANWCZDIBLGiOLNnLKw==
X-Google-Smtp-Source: APXvYqxXNqUAM0fvlH/zi50Wk27cjpI5FFQGNseFDq720LAoDb6G5OVLQaVKjMUksvk/+5vhFoudHw==
X-Received: by 2002:ac8:22b6:: with SMTP id f51mr498154qta.210.1570576722952;
        Tue, 08 Oct 2019 16:18:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j137sm108316qke.64.2019.10.08.16.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 16:18:42 -0700 (PDT)
Date:   Tue, 8 Oct 2019 16:18:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>, alaa@mellanox.com,
        moshe@mellanox.com, Alex Vesker <valex@mellanox.com>
Subject: Re: [PATCH net] net/mlx5: DR, Allow insertion of duplicate rules
Message-ID: <20191008161831.322f025c@cakuba.netronome.com>
In-Reply-To: <1570454005-23749-1-git-send-email-tariqt@mellanox.com>
References: <1570454005-23749-1-git-send-email-tariqt@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Oct 2019 16:13:25 +0300, Tariq Toukan wrote:
> From: Alex Vesker <valex@mellanox.com>
> 
> Duplicate rules were not allowed to be configured with SW steering.
> This restriction caused failures with the replace rule logic done by
> upper layers.
> 
> This fix allows for multiple rules with the same match values, in
> such case the first inserted rules will match.
> 
> Fixes: 41d07074154c ("net/mlx5: DR, Expose steering rule functionality")
> Signed-off-by: Alex Vesker <valex@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Applied, thanks!
