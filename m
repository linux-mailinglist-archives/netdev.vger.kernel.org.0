Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCEAE6467
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 18:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfJ0RQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 13:16:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45397 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfJ0RQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 13:16:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id r1so4860349pgj.12
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 10:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sXnU8nCV2BfhJoFUX/CDVL2xSQlQoK/uzdmFqhYbq38=;
        b=rKM0wlYLRiF2yI/zMxWSkKcHcWYABvfPqGZz5Dl/IU5l3CtFKuOrLLAYGt0lziBXzJ
         dXqYDXt3iBDCMLcgR1O99s8HL4Db2obqQ/snMjO59l7FlqeEhEuMP85jVHhAbisynL/b
         eUQPuUc+Em84Hfynr/YohseEp3+dR/zuDX2OkU1ScG14o+4Hd0MD/KVEBZX1EDCJCKaI
         wbw0YTCbs5ENp/0xIil4o3egQ6ogKM96UvStGz+/ozIWa+0yq2GDaTL37bJND9H1MfLK
         N7K9AyTtNpvqCq/7EZufEPaQxFK8SI4rQL3Xn/d8xtmzsstlPEQi7/ObQVIUbvuoiCSP
         xWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sXnU8nCV2BfhJoFUX/CDVL2xSQlQoK/uzdmFqhYbq38=;
        b=PYP2TdD8bO8jsRxfluM0/xLW7VFnXYUDemAR+JQxTegipsnbXDAoTAZljRcIlpzfBJ
         Cty2K0+N/t1W1AQtMU1Oz1aTK/eMgxlXFsc6lt2xLDyA672wZjl24Y5Z4cPHfK6qlJzD
         nb8S3mdxGYLtHswM5s4ERZAWCgobL6GF2Y6zPz+rYtOsOxKF1WBs5jR3lBl275c35ScQ
         CTvOQ9wnGVCVUiZVdp/zoxwFaSa8Y4PZ3m7xSBxqMmYnI/uRCYtF1ry2cyXGFxxOE1tZ
         +Lu6Kt3U/46GjbEE7/9OO3SXZbvYFJQO1aUcpgsV6IIF+mqxwT976TXDLKqPfGc5Ff4f
         MAJw==
X-Gm-Message-State: APjAAAUxwNrANZ2VA3j8ZZTBftBn2W2sHhXDeH/lIWYS8kyB5MGlTv+C
        m22UO1rbY0iwb0rzqvSGu1HJc3EQk8I=
X-Google-Smtp-Source: APXvYqwCPFCSvQLMw0bUppOAzQXTDNYlkO+IYGOxpm0XAJV+69MhGCOnc8fTx0nd0TQWWEzbbLU0IQ==
X-Received: by 2002:a17:90a:8c92:: with SMTP id b18mr17275087pjo.136.1572196589432;
        Sun, 27 Oct 2019 10:16:29 -0700 (PDT)
Received: from [172.27.227.183] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id q42sm8252698pja.16.2019.10.27.10.16.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 10:16:28 -0700 (PDT)
Subject: Re: [patch iproute2-next v5 0/3] ip: add support for alternative
 names
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, roopa@cumulusnetworks.com,
        dcbw@redhat.com, nikolay@cumulusnetworks.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        f.fainelli@gmail.com, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
References: <20191024102052.4118-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c8201b72-90c4-d8e6-65b9-b7f7ed55f0f5@gmail.com>
Date:   Sun, 27 Oct 2019 11:16:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191024102052.4118-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/19 4:20 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> This patchset adds support for alternative names caching,
> manipulation and usage.
> 

something is still not right with this change:

$ ip li add veth1 type veth peer name veth2
$ ip li prop add dev veth1 altname veth1_by_another_name

$ ip li sh dev veth1
15: veth1@veth2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state
DOWN mode DEFAULT group default qlen 1000
    link/ether 1e:6e:bc:26:52:f6 brd ff:ff:ff:ff:ff:ff
    altname veth1_by_another_name

$ ip li sh dev veth1_by_another_name
Device "veth1_by_another_name" does not exist.

$ ip li set dev veth1_by_another_name up
Error: argument "veth1_by_another_name" is wrong: "dev" not a valid ifname

