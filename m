Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03D916298
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 13:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEGLIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 07:08:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39430 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfEGLIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 07:08:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id v10so9458577wrt.6
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 04:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d9LtJy4/cwav9m9zm9pCTRgTErui9H63/r98rqCx8eU=;
        b=dAgwQfno7usUUZsw7sbrB5r76dzmGLnLRbqeYLk7kg6Xh2t7qVG91QFBP73QSl4HZ4
         iFBLBRVqQtLH3k1+UigK9NJQ9Et1w0phOu0guZay+yj91OcIChMesE+W5sp/5LzJ6fqY
         4cHN4IZpMrHddVdSKIupNWt2G4zwzFCRuhqSlHPl4Jwpg60zmugcEqcFJArWEMK+ckq7
         QF+ohny9F4Fkr8+P9osvL7xyFNaFT3rYQBcmMec9jb3KGbBIs2/xRlANS3JwIEf/pGnK
         7Z8AnX1F4ovbXtdKZEgXhp+jn2B3i1z/HCBmLg0CZi8UxBWd4LiKJMhLkU+iH2KRHRO4
         9DoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d9LtJy4/cwav9m9zm9pCTRgTErui9H63/r98rqCx8eU=;
        b=kZcb0ySG0fwkuFo+0EthutC9t2nR4L91Te7cbUdBJc8G/upd1bJocQwU7b37ii95Zf
         +Dcy9JoyNfxZGea1605CSEm7qNAJwIjeXPjaoMUihFrGdV/u1QZLML+e4Gylqwlq7p7f
         ymF4hti3mcX3EnCYkVp5LN90rJFnjpf1PcjP17Jcu9MwNf0kNRw5JdOSGUcUN+n5DXGV
         Qi3YHO7zdHSwrlA2DKM4hdfxc0x2/whu8xW/V7GhbdfxFtcfC1PjiXXLUVDBVkhIQtZE
         DIpTbZ+PchPCnozuL3yXb1rpZfGYXv+EMcTNGHqrWKsz/0nxysmmFLMlIzb7TMB4PaTI
         zA6g==
X-Gm-Message-State: APjAAAW+oKcw1iOirHloNf1kx2m6euMz0PA/y1TUNIUTz9T+1jCtVy/c
        GdZ7wodPbhgOBkfKLPkKoxnsEzMmLMA=
X-Google-Smtp-Source: APXvYqySsYfeUvDPX0avYoE6dzZuHNctg0hIF0Ey7nmpeLBGF9f/F6TsDmcXZxQ7e8EEjoWV0pO8YQ==
X-Received: by 2002:a5d:4711:: with SMTP id y17mr23504977wrq.122.1557227328250;
        Tue, 07 May 2019 04:08:48 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id f2sm23460781wmh.3.2019.05.07.04.08.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 04:08:47 -0700 (PDT)
Date:   Tue, 7 May 2019 13:08:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next] net/sched: remove block pointer from common
 offload structure
Message-ID: <20190507110847.GA2157@nanopsycho>
References: <20190507002421.32690-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507002421.32690-1-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 07, 2019 at 02:24:21AM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Based on feedback from Jiri avoid carrying a pointer to the tcf_block
>structure in the tc_cls_common_offload structure. Instead store
>a flag in driver private data which indicates if offloads apply
>to a shared block at block binding time.
>
>Suggested-by: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
