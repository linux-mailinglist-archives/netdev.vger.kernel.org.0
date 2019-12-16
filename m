Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A748512053D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfLPMQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:16:01 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:40674 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbfLPMQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:16:01 -0500
Received: by mail-wm1-f50.google.com with SMTP id t14so6426707wmi.5;
        Mon, 16 Dec 2019 04:15:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xpOt/nWEH5e+C/wcINi7KopuFX15NmmEgac9xN5m/Ic=;
        b=YA10gB2PrRIC0cN3b4zAt2ecoOdzAZv1rN9QfE+CjOrPKmVhRt5E9AcvC/GtwqiJtY
         hzTfry+vD8m0HBg1pJZ1KgHWcL9XyVbqq+qt711Zkm3BK5Yp3/kEWlhvpCBWiYL0OxO+
         8g2qr7D33f/DEXPFhsxyNa0EeddBuO7aL52K5Wr4OZy3gW7KuJykFezwYFxMfs0kHhkU
         17mto8KfPbPJ+BQ7JDvjlGbpfoUmCJRhBlh0nz1VbiQt2F10TfHhUw/dnuozXxKRA1fE
         3q217eZDFl6Bf81r12nYaXvtGlaOwiUZFs1YmQy4GVyzk9IBvMOXytfcjdiB1AOxYBq5
         9uWA==
X-Gm-Message-State: APjAAAXDT9OZU/piz8oW1YxnvOPw7aQnjuhIvVujaGQclgGS+Kv1utWS
        0WBdf7Fk6h29UdRq/KupHFE=
X-Google-Smtp-Source: APXvYqy7Wo0RpoiMH51vUwDnupDNyRG8/Z4WXT/m7kZli22Ahm0E7svgVvIVi65Oj38bYTjZE4VPHQ==
X-Received: by 2002:a7b:c218:: with SMTP id x24mr30909776wmi.149.1576498559025;
        Mon, 16 Dec 2019 04:15:59 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id 5sm21517096wrh.5.2019.12.16.04.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 04:15:58 -0800 (PST)
Date:   Mon, 16 Dec 2019 13:15:57 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        peterz@infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bhelgaas@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191216121557.GE30281@dhcp22.suse.cz>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 12-12-19 09:34:14, Yunsheng Lin wrote:
> +CC Michal, Peter, Greg and Bjorn
> Because there has been disscusion about where and how the NUMA_NO_NODE
> should be handled before.

I do not have a full context. What is the question here?
-- 
Michal Hocko
SUSE Labs
