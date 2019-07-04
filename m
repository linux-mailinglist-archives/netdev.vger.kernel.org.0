Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346005F3C8
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfGDHcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:32:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36579 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGDHcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:32:05 -0400
Received: by mail-wm1-f68.google.com with SMTP id u8so4933303wmm.1;
        Thu, 04 Jul 2019 00:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LIycO9Bp5HsEisueoexKc7Ktz+dHZjKCymeUJisu9LE=;
        b=h2TsbIwrEdlwAo+FjRKB5ttID/9BlvxXUuFWQyMBoCiaN+2ndtSyxVEO8h2ERRK2vp
         8XuW0A7vvjn+OVmfdjyDLto+fwJ/3Y/4r6xqNYMPu3RAZCZxg+TxDInw9uytzWIoGQ/3
         BkIHpivNSr7DCUeYvRuZ6MNTK9mYhTooC7UYuo17d/qxwS8N6cejllrf28/8ivTUdyJs
         AwTTm8LYy9PQ1sLO4b9GQZlLIZsYW1H/qVYhcC7Vl0aX05StNIsqNIaOZpHTe818Fdpa
         xjmuEyXI1vna90PmyBvQyhHVfEaG+YIsGUNtW97WracAYjGHZSJRC93Pj8UxiBfqccO7
         oI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LIycO9Bp5HsEisueoexKc7Ktz+dHZjKCymeUJisu9LE=;
        b=F8UQ2SsmyJuFEYtDaGzIV72Ol5/bg2oBHYcAz7A8mJk+JAe0dQLrZ+r1wDh/XevbIT
         F1az86XNFLdLhA3ckUNCqgt/MgEQ1YIGQSduVw+6w+HZLolbUnDWyEi8OXkS2tvkET4D
         1ltgF1AbFFSOmy2V6GlwtyDiOger4/UuON1Jjl8aTBF9Q4vQicl+1R5OUuuibfo+QVnu
         E7qkCOvWmpn5MJ2/kWRBSKQZoWfOC49psIGP0HWKzidJYcOS05DEgfZV35wEzuV0lo7F
         geTsZIcJyCjicC/Eod4YeZmDxZvxndprl4rXrLv+z8IxvDbJD+G/fCyfQ+1Z+d4lcDXZ
         Jcww==
X-Gm-Message-State: APjAAAUrJSnsJ2dsEznY1s8lBiWeo6bS/JX3s5lP02XjovyPBTJ9MzoL
        PlFQVECUrC6rP+RiJAHH7PJeA88=
X-Google-Smtp-Source: APXvYqwS5YuPl+0VZZboG78UNwuk9JWUSV1WNe6aLEYZS6fci6B/aMjrNqbya1Qn+HaL8D6z/nX2UQ==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr11651230wma.114.1562225523452;
        Thu, 04 Jul 2019 00:32:03 -0700 (PDT)
Received: from avx2 ([46.53.251.222])
        by smtp.gmail.com with ESMTPSA id r2sm5571394wme.30.2019.07.04.00.32.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 00:32:02 -0700 (PDT)
Date:   Thu, 4 Jul 2019 10:32:00 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     "Hallsmark, Per" <Per.Hallsmark@windriver.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] let proc net directory inodes reflect to active net
 namespace
Message-ID: <20190704073200.GA2165@avx2>
References: <B7B4BB465792624BAF51F33077E99065DC5D8E5D@ALA-MBD.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B7B4BB465792624BAF51F33077E99065DC5D8E5D@ALA-MBD.corp.ad.wrs.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 11:06:34AM +0000, Hallsmark, Per wrote:

> +struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
> +				      struct proc_dir_entry *parent)
> +{
> +	struct proc_dir_entry *pde;
> +
> +	pde = proc_mkdir_data(name, 0, parent, net);
> +	if (!pde)
> +		return NULL;
> +	pde->proc_dops = &proc_net_dentry_ops;

OK, this is buggy in a different way:
once proc_mkdir_data() returns, proc entry is live and should be fully
ready, so dentry operations should be glued before that.

I'll send proper patch.
