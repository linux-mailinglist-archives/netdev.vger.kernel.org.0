Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF56192A38
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgCYNh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:37:27 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:33150 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbgCYNhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:37:07 -0400
Received: by mail-qv1-f65.google.com with SMTP id p19so1027613qve.0;
        Wed, 25 Mar 2020 06:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tN/ZPWPzljaBn2rqxyHaIgez0Svs63lNRlNuag6Lwkg=;
        b=YtPdVHoYkid5LBxxRbreBIW13G0QhmwwPLbMVmsMjAF7LfKpLjnzwl0zwGqgG/RDne
         lu3e4a4DQgp5TCeNfI2uMlh475/4OZUl4tDtGy5zDQz3qsloLYYh1IWAxhR/CHfoTiV5
         5cBTpsy//7TQ7Plx23fiFE/7t5JQgMhQTnRFOizkrID1LP3IOyLfx7GXqbqmjpB0uZvn
         85CwR72sf0goRJOhDOAAzkFDqkSOeqvQ/2/dKaj6n0zbfvTDP18i1HlRvI/iRRb3iBC+
         kfqshoc1N4HUIVHHIkLsqRox9nT6WPsyXlIigRcwQ3xH6u3uVsa1s7q5kw/efCAfu047
         qVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tN/ZPWPzljaBn2rqxyHaIgez0Svs63lNRlNuag6Lwkg=;
        b=eO9j8X5Uka1n+u//p6URmqdmq+UvBppDz7vf9pMhBbB2bSf+HvekrlXZNBRRvXf4zO
         Lpv9DP5RZlE8cYmAT7rN/GJX2nVw+giWsFPdKbAJkSbZ6PY04V1hRSVkZ5LscF1MwDfx
         FR3Bw6/zyFuimjiKOhjIhrV1W+Eq/sIwEI6UrxWzj/8DhPHpqk+ONbBLlS9oojtm5l1M
         lgWsitK+Muf0YXS0SEe6Gb9nAh7MqFAz1qMyKfrXn6GIFVRjlIlBzxoQjTKN9g55hiUH
         vAC1fqaPssfUl4TTs7VQVhNE2FXJ1b864ebAuqkRdoCUich9J5A/CbTvmYJr3S9Qrcsv
         n2Bw==
X-Gm-Message-State: ANhLgQ2JhU6v437xs++m/tA/K9WivDysL1rBIyrqxTYpEWkszMXoVk97
        XbRbY4fT/7+iSe08PCeXhqU=
X-Google-Smtp-Source: ADFU+vtHafOL0/sDxDC/TwiX6k+vDPa/lK62NYZWZkmpJKFqNlueQF7L2fnunE76gsTyK49g4NE+Ng==
X-Received: by 2002:a0c:a8e2:: with SMTP id h34mr3037807qvc.22.1585143426984;
        Wed, 25 Mar 2020 06:37:06 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g6sm16397956qtd.85.2020.03.25.06.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 06:37:06 -0700 (PDT)
Date:   Wed, 25 Mar 2020 21:37:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net/forwarding: define libs as
 TEST_PROGS_EXTENDED
Message-ID: <20200325133700.GE2159@dhcp-12-139.nay.redhat.com>
References: <20200325084101.9156-1-liuhangbin@gmail.com>
 <20200325102633.GA6391@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325102633.GA6391@plvision.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 12:26:33PM +0200, Vadym Kochan wrote:
> Hi Hangbin Liu,
> 
> On Wed, Mar 25, 2020 at 04:41:01PM +0800, Hangbin Liu wrote:
> > The lib files should not be defined as TEST_PROGS, or we will run them
> > in run_kselftest.sh.
> > 
> > Also remove ethtool_lib.sh exec permission.
> > 
> > Fixes: 81573b18f26d ("selftests/net/forwarding: add Makefile to install tests")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> Thanks for fixing it, sorry for my mistake. Actually forwarding tests
> requires interfaces list as runtime parameter or if it is defined in 
> forwarding.config file, so may be they should not run by run_kselftest
> at all and only added via TEST_PROGS_EXTENDED ?

Before I run forwarding test, I usually do
`cp forwarding.config.sample forwarding.config` first. I think the runner
should aware of this.

Thanks
Hangbin
