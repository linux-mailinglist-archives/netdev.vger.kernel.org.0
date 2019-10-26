Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB4FE5E11
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfJZQiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 12:38:08 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:37102 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfJZQiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 12:38:08 -0400
Received: by mail-il1-f194.google.com with SMTP id v2so4481562ilq.4
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 09:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=99ZyODZMzPg5SeXMMbwHI3OEticiAb7/axb8AyF3mRI=;
        b=YWCAxjhX48sEigoG7rJdD1DaRLmGZkrQ6g4zcwiY6nxxGJqf122SmjDs1o9Rcq7juw
         3kWW4OeWsB/Rky6MNfmQAI2pbrFz3hpEQpbk1Muuiz3ZrD/6f/6vJtIASc+JnxIXMQk8
         VBEcWskNoAu9627UdN5AuYk9ss9R0/Oz8ToE9Dgubl5IFkqYihm/+C91Ibhw7PmS1nd6
         tm/c1mjv654HeB+F+ZnvzuIvBoOl0JpKEyM9finelvMYkUoZ3nClRQJQNZTOQ2k3/kSM
         ZggRwLMn0af1tbKjCgMn9DhVUX4Kj8pqaSoJn5J1kcHGO/AylCArI5BvQUOTtHi4TDQa
         pTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=99ZyODZMzPg5SeXMMbwHI3OEticiAb7/axb8AyF3mRI=;
        b=m/HcLm2W5+PoDOFd+4V8t0eAGZ6juIAM39YssbiUUpzx/N94peQzOcANGfwzZKyrIy
         Ndpnh2KB1mMumDL8Np6JFx6TQh8L4fYRuJuIDRYPHvouhAMc+PLo2/hbC79gRREnQF8o
         yblRqgxFQ0GGhbnMDD95lKcUnr+XFcj7CgiIfY5R1nO+kuT1HVukCv4ycPF1EsEV+RuA
         hDX7w4YxSwtwxsIxYVvhxZlmIkYgjZ9YM40KCRZzTXpXnafdx1TDpMYp0IxDhu8jzxNH
         5uWwJy4tyeTkrCrCJQeKEcKmGV2T2ws3UVqQTOTIkv4iSEp5XYt1pL0qeapSsZd/+Uhb
         XcUg==
X-Gm-Message-State: APjAAAUpBGJdlTNTTK3YaO4gMOfNQdAu3H/kpCcoYLOlE947yw/fjiHA
        Ab+BG3lsIyr0q0gwrxr8e3gWNYIF
X-Google-Smtp-Source: APXvYqzYzGJBaL1KaFe0kJt0NvkGYDqT5osKZYcBLnMuh1Rc68zWYKxahLifBij1rP5aM+f+avWySw==
X-Received: by 2002:a92:5ac2:: with SMTP id b63mr11803314ilg.138.1572107887634;
        Sat, 26 Oct 2019 09:38:07 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:28bb:5544:a8fa:a5fa])
        by smtp.googlemail.com with ESMTPSA id m9sm761470ilc.44.2019.10.26.09.38.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 09:38:06 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] selftests: fib_tests: add more tests for metric
 update
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Beniamino Galvani <bgalvani@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <cover.1572083332.git.pabeni@redhat.com>
 <8dd671ca9cdf27d8b06998c1686b42d83681d352.1572083332.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3179edbf-d5f3-91d3-028b-f62775bdd84d@gmail.com>
Date:   Sat, 26 Oct 2019 10:38:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8dd671ca9cdf27d8b06998c1686b42d83681d352.1572083332.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/19 3:53 AM, Paolo Abeni wrote:
> This patch adds two more tests to ipv4_addr_metric_test() to
> explicitly cover the scenarios fixed by the previous patch.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  tools/testing/selftests/net/fib_tests.sh | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks for adding the tests.

