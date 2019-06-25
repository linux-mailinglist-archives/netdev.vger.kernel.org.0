Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D753B55A48
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFYVxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:53:24 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:41384 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYVxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:53:24 -0400
Received: by mail-ot1-f41.google.com with SMTP id 43so402436otf.8;
        Tue, 25 Jun 2019 14:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=HhdQQDuMjtdwqP7rsksNb1eG4W9pjKho8/STpYKAX41R0IfNFga0zUIs4Vz6lgsRjY
         UO/TEEkVIsRP+N1ulwrtfAa7hcvirTTXFsQK867YKMBSJkM7UbT5ysNPSCF8jiO5dc0z
         wibuO064RTCxquHT4yolSj6Lotxs0VNI2kUiNFXN6WT8VM+uDaRdvGttM5GPKYBwqOrS
         PpiLF8vM4XVJAE1hG8dFC/zPFmLkaFL/v8+xqDK3ZWZr55EOmA605pQRL7H6NIwJmv7W
         R0WDp9HJ7DMtsBltVVlwuVs74l39Rn2/ZifdRZ2r0974A59C8IxXNLwDlNYRHlMB9aec
         g77w==
X-Gm-Message-State: APjAAAV+gZkGZ+Kqz7Td+z0wMDbOGbcVlcOuTqcG+iHrd8WEzl1rH0hb
        diQ5JWEJYYkErQq8GmAeunBq+1uo
X-Google-Smtp-Source: APXvYqwEIXZ7rNy4fOiy3NtwbDRf9bwsI4zAHDn4QDEzOOnYWaIH0Lkb8HfjboP09Rd/MPw3FoLYlg==
X-Received: by 2002:a9d:7b43:: with SMTP id f3mr433052oto.337.1561499603388;
        Tue, 25 Jun 2019 14:53:23 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id w140sm5982177oie.32.2019.06.25.14.53.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:53:22 -0700 (PDT)
Subject: Re: [for-next V2 01/10] linux/dim: Move logic to dim.h
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-2-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <4207f30f-9baf-88a5-0cbe-57b55a4e5621@grimberg.me>
Date:   Tue, 25 Jun 2019 14:53:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-2-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
