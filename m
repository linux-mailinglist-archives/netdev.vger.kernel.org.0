Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFCD1378AD
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 22:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgAJVsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 16:48:07 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:34730 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgAJVsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 16:48:06 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so3686881iof.1
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 13:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=He+VlGdIwBS0xvVOLA7VleKL8vn5/zyQJffzyUUT9lc=;
        b=RgR7wYOK3PjKfRKNDhwe6z7Rt9hpGyBq8JJmUrsNPb2TjdnpoGLSDp3Ogy6MBDLNzU
         TEx+T1qGlA2rp6iHhC/vZyQWa350O25KFxJ9tURwc1t+GON9+0PuDKXZT8hINAuF4a7h
         shK5pMVrJJzMf33ogkDzzDj/IZp5MWeUDaZSNYEhZ0N0eVBPoQaI6oB8UdjSv84O/HHR
         SzFZRGvIfzIK5u2Jf0CLcur31Vka34RcP205CDCfRBK+l1FQWImFpaA9ZvX4CH7Gaefp
         0h3qH6RUY0LHAa+QWNZucze2mcgblGPcJp17QkzbS2t657hZ+uT79dWsS5UzJi4cL20Z
         xENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=He+VlGdIwBS0xvVOLA7VleKL8vn5/zyQJffzyUUT9lc=;
        b=lybbKGCN65tPfzSs9xNAfp5cAk7E9t9rmMBvl3diXiR3kW7sGmb+JrKVRwGNo1FaRX
         GxnlZCucw5UI5UI0ORyxcXYqCMfR9jXwlr7GbxEdPBGSYFeS3q67EVQYHcxWDY1Pg+xg
         0sMg9OXFhLer0aV8igVdnF0JdFlAID0H70Wg5UBOS34gS5iWltkdq9neDyT9KgODCCE4
         Fr8T9ykhRFPc3/ty6fneZu2RbIzhxRI6m48K6/AT83X8OYurc+d3l85S4+f5UHCdkMID
         zYvzk1/YKgQOokVFBZdhnkAWZTETiJSLuaR53+rwGCxJ0zNKS7TjskmjT58bRR7LdiHG
         dAvA==
X-Gm-Message-State: APjAAAX2AOtD6xogdiqcfVT2YITrnQTouaH9cCH6jIeXjV/yvw4G+RUq
        Z+sAAOyWfTdFoNMdf7w4gadnXggF0Ls=
X-Google-Smtp-Source: APXvYqwF5d385tEbDg/Dxc2flHFtrYpELh2mNWF+HtigSlMBCWB/iCOLokGFaljBqm9AaoAHUnenTg==
X-Received: by 2002:a05:6602:2346:: with SMTP id r6mr4553065iot.133.1578692886311;
        Fri, 10 Jan 2020 13:48:06 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:aca7:cb60:c47a:2485? ([2601:282:800:7a:aca7:cb60:c47a:2485])
        by smtp.googlemail.com with ESMTPSA id o10sm829581iob.44.2020.01.10.13.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 13:48:05 -0800 (PST)
Subject: Re: [PATCH net] net/route: remove ip route rtm_src_len, rtm_dst_len
 valid check
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20200110082456.7288-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <49a723db-1698-761d-7c20-49797ed87cd1@gmail.com>
Date:   Fri, 10 Jan 2020 14:48:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110082456.7288-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/20 1:24 AM, Hangbin Liu wrote:
> In patch set e266afa9c7af ("Merge branch
> 'net-use-strict-checks-in-doit-handlers'") we added a check for
> rtm_src_len, rtm_dst_len, which will cause cmds like
> "ip route get 192.0.2.0/24" failed.

kernel does not handle route gets for a range. Any output is specific to
the prefix (192.0.2.0 in your example) so it seems to me the /24 request
should fail.

