Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3418750C5AB
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 02:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiDWAXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 20:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiDWAXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 20:23:06 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046311D567B
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 17:20:11 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id b188so10776473oia.13
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 17:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZEYfGGh5bssfQ9jbK4A59bAfZ16cZ/UHmQq4oZHIGO8=;
        b=H8xF5Gea+mS9spUrgUsLk7lvkG0G5ZY/ehMg29eE2DHnNbie8NoCZon8wrSBC/Oo+T
         /Yy9uSXB579zbUqmlbnMMMZerjXrPj0HR7swqmfZu6C6XuSh7koa9NjwpLrIRmFWwsqh
         9XnscI7NSReG/U0qqNyrHe3/C20na7EjAHd7sCQLtmXwh6sRKOxMaBWz+ObEj/0zKeTg
         EIY04w7hKE+urQawpV0kT/jkD8AZZXkW50oOQVeCQakOJixJ3MteI7tHqQWejiuJXvPA
         iOAfEgaBGU2zU7Tv4DttDRITU1z8yP23K3TnDQMNDPCQw2CWwhgDLexTSB6M2iRXmKqV
         JKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZEYfGGh5bssfQ9jbK4A59bAfZ16cZ/UHmQq4oZHIGO8=;
        b=6Q2mhesBencuO0gIa+k6ju2F1mAH0fKM3TBtB6IPo8Tml+M9yiJ9ScI2QJb+e2FtCq
         0nvLFWk1mJQNFmy7+OBLWIxnP3LFFnnzun0WSw5106+d1CX3CZKZHoO34CqS/k7hJNBf
         hVpmGwfiQjgV0SwKwYqhnr3MRoM7/cnkv+AsmVmvD3XVabHYlWKcoijZ/xrFlB/0QN4p
         PmQ0xXmkwqa6rDl5VG4Xwql4NF+JSmGTEX0yVn3dPHfAr+dloVw/nlsja/9AGbx3NXkP
         dNJhMQUX3BK5+Z+zxSaCv5JFKBvcU/tAe0TWIaqFNqXDs2v4VMoaaE+WUqKDcDl4mTjC
         8Zug==
X-Gm-Message-State: AOAM532PG7VqmpY1bgU7+3yAkI1J506DSxDupSgC94F51MT76VhNW1Gy
        8SfecvXtXlhf5uNtqw6b96s=
X-Google-Smtp-Source: ABdhPJxSQom52sG0Y0wuv3WrkJ9vin6EF3guq3WQgWdWBEjV4X3eay8oHRjcC7RSvvOLKYar0uvSZA==
X-Received: by 2002:a05:6808:159b:b0:322:b103:4c29 with SMTP id t27-20020a056808159b00b00322b1034c29mr7963722oiw.112.1650673210321;
        Fri, 22 Apr 2022 17:20:10 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id m15-20020a9d644f000000b005ce0a146bfcsm1259623otl.59.2022.04.22.17.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 17:20:09 -0700 (PDT)
Message-ID: <b386dcb4-6c1e-c615-f737-e2bb3026b976@gmail.com>
Date:   Fri, 22 Apr 2022 18:20:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [patch iproute2-next] devlink: introduce -h[ex] cmdline option to
 allow dumping numbers in hex format
Content-Language: en-US
To:     Shannon Nelson <snelson@pensando.io>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com
References: <20220419171637.1147925-1-jiri@resnulli.us>
 <56b4d3e4-0274-10d8-0746-954750eac085@pensando.io>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <56b4d3e4-0274-10d8-0746-954750eac085@pensando.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 3:36 PM, Shannon Nelson wrote:
>> @@ -9053,6 +9056,7 @@ int main(int argc, char **argv)
>>           { "statistics",        no_argument,        NULL, 's' },
>>           { "Netns",        required_argument,    NULL, 'N' },
>>           { "iec",        no_argument,        NULL, 'i' },
>> +        { "hex",        no_argument,        NULL, 'h' },
> 
> Can we use 'x' instead of 'h' here?  Most times '-h' means 'help', and
> might surprise unsuspecting users when it isn't a help flag.
> 

agreed. -h almost always means help
