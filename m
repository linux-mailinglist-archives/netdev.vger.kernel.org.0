Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C182FF987
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 01:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbhAVAiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 19:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbhAVAiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 19:38:18 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B58C0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 16:37:38 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c6so4705272ede.0
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 16:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TeiiYFAvFSYzNBI2SWQAdJpUXSJc3smyHstzLgHU/RI=;
        b=Rn9/vvpqWyJRaLXupxaA3MdFkSND36ByLececSl0UMpO2wnaTxS0mleNOnEH8UHtF8
         EQbLksYkwbpBOtUjW3uinSRiL19ArLJvSAKxvnC4oNv61kqjQKDBHCT/Kfz9wxDrlKQG
         ey6Lc9kDYitRG7+m6q6sTgj5I2E2//h70vrdPcrNNbkGJc3bmbgSLO8cu3WBgTTUSu5Y
         u9p6rbM9t4tjtB5vanmmMLyskkZZ2RI1ZaueaMXdnjHxkPE9gCsBq1oo4U39bn8TkkLW
         LLJ+efZCtwBQJJPZSmNSfxqInFuX7cROma/XFXWFBWMN5p7Mi7yEZWd+ZED2zZmT9Nc/
         577A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TeiiYFAvFSYzNBI2SWQAdJpUXSJc3smyHstzLgHU/RI=;
        b=fN2J8CamNkwG59bRNM6z21/LNysLX0MkdSrcyD1Kxzq2PcAJfnFZL104zUW8y5CbbC
         0/coXRz1FnXWVJOaZREdHaZZx3yQArNx/GpdK1Op51yQqk0TP7y4LeWQAYo8vdBByDws
         3SuHB5uwza8+KSerNX9juJA6m3HdhyO+zUp/Sr5a/eK0baa1/F7ZcSjOR7/MCYLEtxRI
         BahtBCoErA5AoNY4CWzGRgwieNKupBvA8ojk6J6WUM6XugyVhwJ6Sxga4yHXhkabdxOX
         1GD/8gkjLn6UK12KKuWtlkQglOqALZuhVqz/egQWzO0z+r7p7Fz6bppNHSABqtZEA/d4
         WEWQ==
X-Gm-Message-State: AOAM531doraIRu7/XC45arC0TFHRwnjz9UTHV8ngJBQxUPIkCvwZ07dV
        hrwBkrLaIv64rbiclLFMVUM=
X-Google-Smtp-Source: ABdhPJyWMN9OB3y1UGE6C7JB2TVQB14/nVBEGNgq6jxQ/5uDw6xNg0UYyi31476DCC3kftwhITcIbw==
X-Received: by 2002:a05:6402:1383:: with SMTP id b3mr1292384edv.100.1611275857110;
        Thu, 21 Jan 2021 16:37:37 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bo20sm3796975edb.1.2021.01.21.16.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 16:37:36 -0800 (PST)
Date:   Fri, 22 Jan 2021 02:37:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>
Subject: Re: [PATCH iproute2] man: tc-taprio.8: document the full offload
 feature
Message-ID: <20210122003735.33op5zc7cxvrl7cu@skbuf>
References: <20210121214708.2477352-1-olteanv@gmail.com>
 <20210121215719.fimgnp5j6ngckjkl@skbuf>
 <229d141f-2335-7e6d-838d-6ff7cd3723a0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <229d141f-2335-7e6d-838d-6ff7cd3723a0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 04:10:06PM -0700, David Ahern wrote:
> On 1/21/21 2:57 PM, Vladimir Oltean wrote:
> > On Thu, Jan 21, 2021 at 11:47:08PM +0200, Vladimir Oltean wrote:
> >> +Enables the full-offload feature. In this mode, taprio will pass the gate
> >> +control list to the NIC which will execute cyclically it in hardware.
> > 
> > Ugh, I meant "execute it cyclically" not "execute cyclically it".
> > David, could you fix this up or do I need to resend?
> > 
> 
> I'll fix up

And I just noticed that ".BR etf(8)" needs to be on a line of its own. Sorry...
