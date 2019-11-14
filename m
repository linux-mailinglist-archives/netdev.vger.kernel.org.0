Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E68FCB3F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKNRA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:00:57 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39078 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfKNRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 12:00:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id 29so4146138pgm.6
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 09:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6bO7e6hWYl53t03anT/Z1zUE/FznVpwaBWq+FDBPOFw=;
        b=sk59Sxa2ql+seW2RmX9NyqQTrkbW9s/bSh8AA1Z5jYFL/X7vqVEwE93ZDDJ/q8Ymbj
         Fmu1zUaUHdrvARX7jQ53KEP23AgKmakA97LTT01nZdvxL9+qWFff/I0gdTt3ITzqu4Ny
         4r/sWDtJg054Fhg90F1n3K+hTuI6KqA9ax4gUQTWvaSGsJlPK5qgZr1nouxPjuE14qof
         9f8jmkityB8eL0Kw7oTGeVuecjfmoLzbj7V1zb5TC0Rc5PPOz3HDoPWEc6SY2LmsqRmQ
         30WOdXNzT63MinUon6Zf/uGxvAfk0FNL+Eiegcbf1KVwmvgpBlpCueVTOja6xctBQ7sa
         +log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6bO7e6hWYl53t03anT/Z1zUE/FznVpwaBWq+FDBPOFw=;
        b=gQ8Rxq8cRY52ofvyD/K7A3RDrdJETD7ycoI2iN7CAwXrTLToc7oMpxUi1vLLIowHE3
         fxLpISmmSs4x/zCMCQGKgbQ/jAcX2ywwb3RMqy3C9p4RCjKNDEMqPN/ptOMhYE+TP4BU
         1D6QxfmKXQ7OyARIH8QqYTfb/2PFD+KrcPVTAyVq0Tb5kjIgJ6SIlrfTJHD2YbFnSnnO
         kySZrsIIrGkO5XzfafNAC6xPtzwdoR2XtZJpZlYVHM2J1fQbU37OebHD8owikQ2LGJrp
         vTcUiBO8jDmgYuHq9faQH78rZcDIssTS729Q8IzMw9zUp/7439nO9tuUZwUPZmMtJbvN
         4TJg==
X-Gm-Message-State: APjAAAWkZ/yv17O17dmlJHgmMl78wjvg5uN/ks7b3thxTkb2bk3FEYo6
        TI/p+vhMNs6XWP+4rqR/KX+eAw==
X-Google-Smtp-Source: APXvYqx8uPXf4czd3iKUV0VVk5MDGgysrPrpM6yFUYmtbUIKVtFNriO8qzyTyMZgTmgiZz3P1aI5bQ==
X-Received: by 2002:a63:cc56:: with SMTP id q22mr11217252pgi.439.1573750854560;
        Thu, 14 Nov 2019 09:00:54 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id d25sm8101407pfq.70.2019.11.14.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 09:00:54 -0800 (PST)
Date:   Thu, 14 Nov 2019 09:00:49 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <borisp@mellanox.com>, <aviadye@mellanox.com>,
        <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/tls: Fix unused function warning
Message-ID: <20191114090049.47cfee19@cakuba.netronome.com>
In-Reply-To: <20191114073946.46340-1-yuehaibing@huawei.com>
References: <20191114073946.46340-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 15:39:46 +0800, YueHaibing wrote:
> If PROC_FS is not set, gcc warning this:
> 
> net/tls/tls_proc.c:23:12: warning:
>  'tls_statistics_seq_show' defined but not used [-Wunused-function]
> 
> Use #ifdef to guard this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
