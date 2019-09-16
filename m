Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12ACB3CDA
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfIPOtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:49:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43137 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfIPOtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:49:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id a2so21176pfo.10
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SQCmufhP1zEnyRjTQEvgJOrGjugSs2/vBykGIrI66+Q=;
        b=nIh3F4zg+oH5PkM6upEXlGYEghSckIgZrWxHNFz3EcsZgklyvaDPEaL0rw1UEzBTnx
         Kk88HJRkUYR5h1VKZQBnehRqc0QlGTJ+MPUpzwzhXkl+S21CdNcRtYKM2YqbWaRzU0pt
         rtFVgQhwZq9bv4tDsbTxGZCbWno2RfNiURt2Z7yiUleT9Rv7FK90JjOk7ZJ0wdIzmFSq
         CZu8I7BONB9b1GBwQ0Vt6KR0RJmTkLIAtwcfW9d7YXpeIWDCrs1Km8ksZ/pFKvb6nnpk
         gtRrakBJQ7rt/4at5cvqDb1YAEeogmkEwL92dr7+HVXKObTSncMxlnEfca/nNiq862A+
         bkWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SQCmufhP1zEnyRjTQEvgJOrGjugSs2/vBykGIrI66+Q=;
        b=Gt0S/zTfNJzCkXlQzI9tu0B3nDHGypA4feY5RGs40SfOjvmI8kYCtHuDVfDlFPcwT8
         cGjdlbB7l3fStM0AfaIISMDkbvCrs8aJFywcDOX5JNK1NQiYu2OmKcnbYXA3+tWeaPDQ
         1yfmCGN1MtqSlg4Zngh1h1PiN9TlltW13xVVc3by0ZtdYoXmVgs1AVIAkJTZGv2NqiCL
         zR+l14xAe9xOL/y7sAEPqWMtfsDfZlY2qpgRjkIqRCthVpYgihdJGcUUFgmY/msoE0GQ
         tRy0Hm9y61W3NnKNJATtkOaph5+DCo+iJoTws9UZeCuPoEAUiDQWsx9BDY7I6WeFZdQ0
         nMjQ==
X-Gm-Message-State: APjAAAUKPsYVxqCMt6aoLHaaS50k6EaVSt8aoWML4SszqBfBcLvp+RVV
        mYPSdosKbjg8nhFIK3FWxco=
X-Google-Smtp-Source: APXvYqzfjot9q/5sr38cd/kQWC4MR+lGpGhNiFanCOxN7DxlDlg8p7BPzXtHV+np2NIbGGGjvAA/VA==
X-Received: by 2002:aa7:8e59:: with SMTP id d25mr7050853pfr.89.1568645355193;
        Mon, 16 Sep 2019 07:49:15 -0700 (PDT)
Received: from [172.27.227.245] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 127sm64189551pfy.56.2019.09.16.07.49.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 07:49:13 -0700 (PDT)
Subject: Re: [patch iproute2-next v4 0/2] devlink: couple forgotten flash
 patches
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
References: <20190912112938.2292-1-jiri@resnulli.us>
 <2c201359-2fa4-b1e4-061b-64a53eb30920@gmail.com>
 <20190914060012.GC2276@nanopsycho.orion>
 <7f32dc69-7cc1-4488-a1b6-94db64748630@gmail.com>
 <20190916100924.GM2286@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7d3ad854-deba-45e2-fb10-b5a9c9587a04@gmail.com>
Date:   Mon, 16 Sep 2019 08:49:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190916100924.GM2286@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/19 4:09 AM, Jiri Pirko wrote:
> The fact that the file is expected to be in /lib/firmware is in the
> devlink flash description right above:
> 
> 
>    devlink dev flash - write device's non-volatile memory.
>        DEV - specifies the devlink device to write to.
> 
>        file PATH - Path to the file which will be written into device's flash. The path needs to be relative to one of the directories
>        searched by the kernel firmware loaded, such as /lib/firmware. 

fine. applied both to iproute2-next.
