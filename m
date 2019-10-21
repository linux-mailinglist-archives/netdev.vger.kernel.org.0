Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA2DF124
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbfJUPUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:20:11 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:41814 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJUPUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 11:20:11 -0400
Received: by mail-il1-f181.google.com with SMTP id z10so12358033ilo.8
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 08:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W0Yl2n8jDYG3DuryFaId30I725kfvf082PVkSgDyVsY=;
        b=CtjTL1h6IMaNfFHnulLQu5w7C0W1yqMk6527Eef5i+jJPXYRw2QkN1728rXKLHuEJ1
         yVjosL0rGtBLWh/45uwBmgFqLlWPFmMOnBV8DBUL63FqBDi3BwI0E6+JWWQfSJGU4LRN
         aXKWF2g51FbtaQMWl+YIHVluwO6OXlWIcsG8kxPk7yW34Rxjd6PVsVqjhJOG7r91HLFH
         Wqh16PVvCyzcv5cVoS0A9RmTD0LdBz36vuWR5ETOARZYlX/G1cccaoLkIZFHLcNFg9MQ
         JektBHhqImG7kK/2y2LxvcrcznGXFtJNJdvpLSc57z045yIsnkOG6yn+TPpCqzqfcax/
         LScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W0Yl2n8jDYG3DuryFaId30I725kfvf082PVkSgDyVsY=;
        b=FK5PFf7nm0vxeIXZEc64ScTtr6DB2kC8fu2+wFqihMHjWxbzg95Yh/1sI+kjK3fxcM
         HvvX9aUD0TAWsoM6aZOTecz5G4RILw9wEeK4l8bhwLnWeqRg6AIBP/y0YkdIC+qV70jz
         vDUabLuuXAOZtC11T4va00FXPP2a9AjQ35gAeVS2oqHACrjwweCVHR4n+OIrxtJnyL9Q
         ZHjoxndBG1/Pvlr1iQp3EP0/nU3pXJD+WvYubhh1jbmf4OJfOUTSmqsob1OCjtP7LMER
         OuxFAtaNE16Uu7cnUbri2lCI5wYPpdbbdzDDzS4XQcbfq3RNQcfquiMp6O9WltPwPewQ
         a2qQ==
X-Gm-Message-State: APjAAAVw1t78b6idxvpZup5KX9se+oW0ezTWZTeg+YjLkmv6DxX0Np2p
        atJr3ZUrm+ymV54NJmxTpo0=
X-Google-Smtp-Source: APXvYqw7PENIEH12vWEWoKvFbck9THQSsbZeIz7jGJjDYQ9XCxFbCUpdW7kG6itd7aouYEnJtcoGLg==
X-Received: by 2002:a92:188:: with SMTP id 130mr5385031ilb.177.1571671210410;
        Mon, 21 Oct 2019 08:20:10 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:7597:dfa8:dfb:f346])
        by smtp.googlemail.com with ESMTPSA id t9sm758775ios.66.2019.10.21.08.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:20:09 -0700 (PDT)
Subject: Re: [patch net-next v3 3/3] devlink: add format requirement for
 devlink object names
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-4-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
Date:   Mon, 21 Oct 2019 09:20:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021142613.26657-4-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 8:26 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, the name format is not required by the code, however it is
> required during patch review. All params added until now are in-lined
> with the following format:
> 1) lowercase characters, digits and underscored are allowed
> 2) underscore is neither at the beginning nor at the end and
>    there is no more than one in a row.
> 
> Add checker to the code to require this format from drivers and warn if
> they don't follow. This applies to params, resources, reporters,
> traps, trap groups, dpipe tables and dpipe fields.
> 

This seems random and without any real cause. There is no reason to
exclude dash and uppercase for example in the names.

