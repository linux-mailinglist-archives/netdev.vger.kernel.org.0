Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4E7304A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfGXNx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:53:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46558 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfGXNx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:53:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id k189so2237093pgk.13;
        Wed, 24 Jul 2019 06:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=88pXUcI9m7RWL7dOzPhNJD4mwHzMS+qrMeEnOmuhYac=;
        b=FwaCjE4FdMMna5fqTMTNs7tCMkBlUt9U/XCAKIJOnxL6m7VPGuHPJcnIylhB40TldK
         x94bN8SRVxAk9bGYQDoQlCu3o9KkVj3MesZzsvXnwan3XjyaF+nPThXYHtSrwo/K3KxQ
         1UjBrTWxPRoyehktQghAVdd+5u24RYDonebi5L5SUuT5M6noPF9XrO43RhpxgfXvozA3
         TZMxZ0KKoLf1wPo66EKJs3BpuzXSVo5luZgnZ7qBhghu2StKqkJHZC6W5z5zXHX62h8+
         jKxdW3Fjg7ATq9Ihhej0N5tD/HjjunI1/H1tYcqKs34HFukE6XbczwdsOFa1EShCn2SV
         s5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=88pXUcI9m7RWL7dOzPhNJD4mwHzMS+qrMeEnOmuhYac=;
        b=Tb6zH/KCr510TX6VvAXXbZ6mytJWlBySRIqCfgrsV2w3KC5a+vXjGtcBaNRtvB+dNv
         jhnpuibt22YD2t2ygFe1tLTMjxg2ySWkwo5ZHTEFllBMlajn2HtH0QFjeXV0OKG7KrmM
         5hEB+f7cHaSsnzj45OnFUNR3JWQUPXmdsFS9Y6d+pGbmWllun5Ek7fvxel3S50jSnVH9
         bJOLoGdUy+ChlEjoH1Qo9EyjvmI0Nh9wWM9ziawEHaGocOhVY2VlM8BaHQlH2Yj9iQza
         ghTipVE3clwVPBDTefM/c7XGsLMNJXIWwU6Mm1hJ+g7F2Q11vZF4/X9zjfpEDcljwihp
         b2uQ==
X-Gm-Message-State: APjAAAUTkR+4ZrKIzS645VeagWzpQx3e1OYlU/sTxc+bRmtBrmhiEMDP
        ApvQ61fluDD2tnvAfJlIOb4=
X-Google-Smtp-Source: APXvYqymc/InOLIKLmbk0f+vQjsaxWv+Lvon5yMznzRHEJdzRT249x9IQSvH2N7xZgHodXHC9pQL5g==
X-Received: by 2002:a63:df06:: with SMTP id u6mr28218818pgg.96.1563976438163;
        Wed, 24 Jul 2019 06:53:58 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id b36sm71105951pjc.16.2019.07.24.06.53.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 06:53:57 -0700 (PDT)
Date:   Wed, 24 Jul 2019 06:53:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v3 8/8] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190724135354.GB1300@localhost>
References: <20190724081715.29159-1-antoine.tenart@bootlin.com>
 <20190724081715.29159-9-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724081715.29159-9-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:17:15AM +0200, Antoine Tenart wrote:
> This patch adds support for PTP Hardware Clock (PHC) to the Ocelot
> switch for both PTP 1-step and 2-step modes.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
