Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE4D1C1AA1
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgEAQdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 12:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgEAQdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 12:33:39 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8046C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 09:33:38 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id y19so4993116qvv.4
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 09:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=alaM4Iu8W6mw1vOf3aby4nclbQ7Zl/1CqJFIqQOAqnc=;
        b=GsauiK+GYfejmhIXgzXHpysblE+n+vMJB9TbKTE+tKy3/FxW3Agfa4+06mwjayIcQy
         BdT+y2nvijLNNzfV/fQlnAubhPqxU4qkZeQfMU/HSKTa0px7GVa2yXW+L2TuJ/eYRhb+
         cGPURGLvYdOKhfG3IOTwNakkTB2H+SIqBBdzi2xbl6h8MVcuNp4QBexbkytiFUh+yvvZ
         /ws/z/PGMGkSD3P4dpTsGecg8m/EDguLoHNIVW3zZg/PdPEJELRslBUjKIbq/pNmx64J
         dvU5HQJVWkNqjPrvb9T/qI4u2rSxag4uoLZFisIW42Px60bYCtJpZAb3VWPpz7llrg0z
         OdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=alaM4Iu8W6mw1vOf3aby4nclbQ7Zl/1CqJFIqQOAqnc=;
        b=mz/wb03BhjTgBr+HWOzjqB7r7NNEADMDKT0JYqVf+I+3fWq/Fxn6olKnho6hBKne8K
         q1g24G7RwVfX/wlNVMRHsJTEdkIiTxDPypglKwXywAlMpbohEC9ZyaxwLbhGEHn5N3a0
         0YWXus6csX/G2AqiU2UiPqgPciUIg7WIeSJp4i8/o0hCFZsTDK/9VvORNX9U0psPVQTi
         JX9pj+0wYrBM0VA2mZL7YsmSBSZ724JFtmHxKFWyTNQUQ34jl1QmT92VtbNm6EyF0U1U
         fRWT+Jj6G5Uukd7+BpLZUzIYKAk2jwxXyWDnH4kNt0Myjf92bo9u/DHFWnGjXgxBrY94
         Du8g==
X-Gm-Message-State: AGi0Puaj8oP861gaPVMN/UNrUOTQMAvm907IOUePIa1jLnWrGd5SGthO
        5fumC/MEUWBEA9I4cShdhUfPfX2q
X-Google-Smtp-Source: APiQypKQqGdH4gCcYzoeY1VAtPtstI6xNBZP5ITv+UKzLLDOVaQtXj1KnbFQt9xLX3Y8vEzNvkfLkw==
X-Received: by 2002:a0c:ec07:: with SMTP id y7mr4818341qvo.183.1588350818149;
        Fri, 01 May 2020 09:33:38 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b01c:ec8e:d8ff:35b1? ([2601:282:803:7700:b01c:ec8e:d8ff:35b1])
        by smtp.googlemail.com with ESMTPSA id m25sm3065160qkg.83.2020.05.01.09.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 09:33:37 -0700 (PDT)
Subject: Re: [PATCHv4 iproute2-next 0/7] iproute2: fully support for
 geneve/vxlan/erspan options
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
References: <cover.1587983178.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3daa50a6-ddc0-5cc2-c5d3-ce3938868b2a@gmail.com>
Date:   Fri, 1 May 2020 10:33:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 4:27 AM, Xin Long wrote:
> Patch 1-3 add the geneve/vxlan/erspan options support for
> iproute_lwtunnel, and Patch 4-5 add the vxlan/erspan options
> for tc m_tunnel_key, and Patch 6-7 add the vxlan/erspan options
> for tc f_flower.
> 
> In kernel space, these features have been supported since these
> patchsets:
> 
>   https://patchwork.ozlabs.org/cover/1190172/
>   https://patchwork.ozlabs.org/cover/1198854/
> 

fixed the gdp -> gbp typo and applied to iproute2-next. Thanks

