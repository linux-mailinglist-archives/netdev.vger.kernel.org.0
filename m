Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B5918F970
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgCWQP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:15:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35074 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbgCWQP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 12:15:27 -0400
Received: by mail-qk1-f195.google.com with SMTP id k13so4106135qki.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 09:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rwNGBtSTqaJJ72a3OAj4cNUqgR9c72chx5KZmMySeqQ=;
        b=Ce8vkN56aIGlWyFkouqguG1JMdSyYt5uVKTz0vffBFToBE++TWV4wHeWMY8W45A0SD
         bcLoPFLCsUdHHs/ZIYxxH9NzIPmtFh36GEjoeWGM3BpBkzvVlGlYYSSwueaIx64Q6q/v
         DSlrk8pZDpxSzn8xr49NMwnrjZBA8ULqGl+fARD2c9/p9aKC7vBlZmvER/xShFM2Nq3H
         eTgOZhQc7VmTwmX6XOrmtGYTxYkBgeR6a9buGF/wp5Zaa22CDfWb6w1LDVzr7laRGKez
         Wg4flSBQreIA8R3Pv+OivfBB7pjJz31yIJH/GbeC1TQvu6+2i+HsFSLYNnNyPctNJXUh
         U8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rwNGBtSTqaJJ72a3OAj4cNUqgR9c72chx5KZmMySeqQ=;
        b=arql5V4qF3ig/+dgGJmdS1CNU7FVUhVZpabuAaLtFUrTPBAnZ2oRFCeCzZ1OqpiW+e
         wytNAgOON2Y/rCEetwLqnwn2WPPROONgZ+m7RcBJOl7mmtmp7B3seMKAJ0ODDMhH6Osj
         yVQVQG7qFJGeJvIF3t0Xw8MwOwfJLLKEqTn2qlmxrZ3Yd0f5XzkfPGKOpVzqCCbPmKjc
         1jRfUhzzKR6knTqEo5OdISZukC3FeVIT9S0LWJEJQNwDNCgoElBzGgFReX8wuZmzSUvj
         t+1nL94hSoi7oUwWZbs6ZuloK+RHTe53A4JmsuJAKc3GH98YXrBKuLmnxkROzJEdWrH1
         Z3dg==
X-Gm-Message-State: ANhLgQ1btONlNUG1RezwbZzdt706/a7OFm34jTQsn/HDAHvYbQvKp0+r
        Uf/4WYxoh9hfFxBktHnDEM+QXRsp
X-Google-Smtp-Source: ADFU+vsCllsUWztWhAqQ4QnElaAalRY5DmZy7UYwN593fZuFEfhx1At5PMCp+sDmSZWTM/HANF2yxQ==
X-Received: by 2002:a37:4c8d:: with SMTP id z135mr20780322qka.128.1584980126416;
        Mon, 23 Mar 2020 09:15:26 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:ec36:91c:efc1:e971? ([2601:282:803:7700:ec36:91c:efc1:e971])
        by smtp.googlemail.com with ESMTPSA id 128sm11493349qki.103.2020.03.23.09.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:15:25 -0700 (PDT)
Subject: Re: [PATCH net-next] Remove DST_HOST
To:     David Laight <David.Laight@ACULAB.COM>,
        Network Development <netdev@vger.kernel.org>
References: <746901f88f174ea8bda66e37f92961e6@AcuMS.aculab.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1daa5b45-1507-5899-609c-1ebbc7816db1@gmail.com>
Date:   Mon, 23 Mar 2020 10:15:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <746901f88f174ea8bda66e37f92961e6@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/20 8:31 AM, David Laight wrote:
> Previous changes to the IP routing code have removed all the
> tests for the DS_HOST route flag.
> Remove the flags and all the code that sets it.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
> AFAICT the DST_HOST flag in route table entries hasn't been
> looked at since v4.2-rc1.

even back in 4.14 it was set and only checked in one spot -
fib6_commit_metrics.

> 
> A quick search failed to find the commit that removed the
> tests for it from ipv6/route.c
> I suspect other changes got added on top.

been on my to-do list to verify it was no longer needed. thanks for sending.

Acked-by: David Ahern <dsahern@gmail.com>
