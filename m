Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D4EDF28E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfJUQLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:11:38 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:47014 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfJUQLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:11:38 -0400
Received: by mail-qt1-f179.google.com with SMTP id u22so21781724qtq.13
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 09:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=liquc+SgXcW6QjaTGfqdK1ahAvSbMjz9Zx5gMjmFApY=;
        b=EdPmlE/P8qdMBsqqQLQKvRDyBDzEtXS4V3yxO4OywSe3v1ksUi9KC9+UTungoWNToc
         cEO0sylwqDzs+N/4Rd3sczxKcTePMtpV2X/MGT1f/7L3KKXLmHcVEj4WSVrve3Nb9NGV
         WYZ1m/qyzpf/McktQN/D13Y89lqQF3fF66SmCqobcGoyZq0WwCa5s83RDX6h6pkFL3NO
         /8CBNTYklbD8ySvUM47ieIbaOoAYKD29T/s3TokDGy4Gi4r20HDeICuJAQVDTRf246pi
         qnoO+vsSD3ZimQlZQ3NdjVClpWQweBL8liGy3XI4xLgAGCcxTzsDRJAQXkQGfEHwjBEr
         s/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=liquc+SgXcW6QjaTGfqdK1ahAvSbMjz9Zx5gMjmFApY=;
        b=JwkX757Oi9UHCx5g9lFA9NX2gC8TjvhBMomJvmiY3PdfJMjpy34C/9scdVzZot1na1
         4lsbLSV3fiTAPCFPHoZSujIUKSHoVyDYlMtDFKo6dN+LrUpeXVQkRt95YbYf8V+pmGQi
         +OgMXUbrZo46DNnicNquZUJuN3tVjxFyREwbzU/Kf1DefYaBFXgMceDfky2EsD0TJapC
         NOlJt+Bo/FcXt7xkzUGm55uYn5oRa55flXec4oqw22HpfNIDsNvk5bNUpKOkcjImXwIE
         tb9bAMF91ZO/+ZBhLuhgZdd7GPH/NVyzbYXx/7j4MzYSaZljM4x1clW/Aj5NESUr/EUw
         zfiA==
X-Gm-Message-State: APjAAAWTsr66MVcti/5K8k2Vm4X3RQlYmtpoaEJPrXrxkOI+fP3wEZfc
        CVKJ5YOWrCQezyt5njn+W3I=
X-Google-Smtp-Source: APXvYqzbh84d5b4yV+1xq+Dh35NC962yEkKtEHWHUjFKBIytCaryV9usM2c7Uy5bK3C6IJ5V/6t8sg==
X-Received: by 2002:a05:6214:1707:: with SMTP id db7mr6887144qvb.198.1571674297578;
        Mon, 21 Oct 2019 09:11:37 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:7597:dfa8:dfb:f346])
        by smtp.googlemail.com with ESMTPSA id 56sm17379839qty.15.2019.10.21.09.11.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 09:11:36 -0700 (PDT)
Subject: Re: [patch net-next v3 3/3] devlink: add format requirement for
 devlink object names
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-4-jiri@resnulli.us>
 <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
 <20191021155630.GY2185@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0f165d72-bb54-f1cb-aaf7-c8a20d15ee49@gmail.com>
Date:   Mon, 21 Oct 2019 10:11:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021155630.GY2185@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 9:56 AM, Jiri Pirko wrote:
> 
> I forgot to update the desc. Uppercase chars are now allowed as Andrew
> requested. Regarding dash, it could be allowed of course. But why isn't
> "_" enough. I mean, I think it would be good to maintain allowed chars
> within a limit.

That's a personal style question. Is "fib-rules" less readable than
"fib_rules"? Why put such limitations in place if there is no
justifiable reason?
