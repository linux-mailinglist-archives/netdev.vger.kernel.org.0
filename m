Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91947CE654
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfJGPCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:02:54 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45200 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGPCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:02:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id q7so8352350pgi.12;
        Mon, 07 Oct 2019 08:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xo+F+lglD7YCqQaFkJ9g7GSCaFFC/m/5UdoVnBjWChY=;
        b=rVdKdJT9p7TDvsBtlmAqzhvDSWKJ0xuP2lDmb2apbeoH3Q2HLw2JwT3siWGcVOorV9
         ABpUmFPPIZKsq8lmvzJsaYBeQUTSLGMIIg+Nz3AZsujCcEVFAQz6A81Q0+Zp6/8O11e/
         TMpkZg104WREkqCZCMihVl1OC9Cn5RUDtw+Pvj1F8HHE4vefao/maL9kKDtQjCLIGcMp
         +Eb+NWAui5UX8ZAdj3i+67vQYuxDaUkB5rsr/uELMDNmxJqEXnHqPU+ZVl/CnsnpjGeM
         ykcy3T/05On6PsZLTYArufphtTuc41717e1o9DrHgxka+ZEh+5D7YKuAs7jX1+5T6els
         8jIw==
X-Gm-Message-State: APjAAAXrR2o+k4DWKGElkJDQJk/KbcAit2qP5VBJiJ17IKmnHCQADh89
        NkOKbrEugE/tBAw3eN/BK9a0Gkk/
X-Google-Smtp-Source: APXvYqyADB27+A7ddOLl7/xfXJ084pwvX5TbaqmLHbYOz+xU3JEfwmUp1tu07Lg2aYx7hjn+QqPWlw==
X-Received: by 2002:a65:628f:: with SMTP id f15mr31735662pgv.215.1570460572445;
        Mon, 07 Oct 2019 08:02:52 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a8sm15391634pff.5.2019.10.07.08.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:02:51 -0700 (PDT)
Subject: Re: [PATCH mlx5-next v2 1/3] net/mlx5: Expose optimal performance
 scatter entries capability
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-2-leon@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cfae2979-1ba4-e20d-ed20-1cb8f26b78f6@acm.org>
Date:   Mon, 7 Oct 2019 08:02:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191007135933.12483-2-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/19 6:59 AM, Leon Romanovsky wrote:
> -	u8         reserved_at_c0[0x8];
> +	u8         max_sgl_for_optimized_performance[0x8];

Should the name of this member variable perhaps be changed into 
"max_sgl_for_optimal_performance"?

Thanks,

Bart.
