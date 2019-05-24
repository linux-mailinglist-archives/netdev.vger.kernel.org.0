Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EC229DA2
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfEXR5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:57:55 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:34593 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfEXR5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:57:54 -0400
Received: by mail-vs1-f68.google.com with SMTP id q64so6415301vsd.1;
        Fri, 24 May 2019 10:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=xsHpHXSkRG30rT1Gebig5Ode0f+Go1ChQZY26jIIXn8=;
        b=mDgsvVGICwKVo8Ff+lHccYlhJ3uc9K6ujYOICfC/U00blP02IIgpILC2MQbcNAoSQk
         srM9l51RM7U2OfoyeTqqffBh6cmUjyEnE6hvyEtlcOTK3GCZlTieZikSdmJD5CP/YAja
         afIrjked50mJppRtlNgkeY/oZgrWfJ7Z6+HZAwfMZy6pj3+XDUPePBO3gRKl2bDfvqB+
         7HAnZem3z1qJQ25lzvXHK1vJqLTuC4RGbD/Y9QzBZA6KWpZ/bnQ1Gja4LbKuBhkuzuXy
         CtNq/Sn9C+uzJcJUR7tezOJ/5XtMliRPRM+nQwwaUlgjuQLRR78T6RJ7oq1g/54eSRCT
         RhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=xsHpHXSkRG30rT1Gebig5Ode0f+Go1ChQZY26jIIXn8=;
        b=bpME/qxIjREfzAH0YyXe8hIl1VvsM9Uk6tMdSWqq3Acp2loUEYCgXH5vMRuR4ahSGZ
         R6vfnLG0N5D9uIFDUy2M19TdVu7xbO21DZeLoZVL4Gs1rd3CxfwBpS1G3TxAK2RaozBK
         zZmmbKi3ckS+NaO59eTD+usBRdlrYSotV73fD3p2DkaWCbVaFoHGJs3TiwFk3usQftq0
         4QJ4Ldl28m7WV2rpPtn7O0BPYV+EvmJ579xe1xFBWWE7GqbDtYg80X1sH8X/ePeaItI+
         G0JNaezDoWQRuccK8+07yH/fWPV/VNZdsGTZxp62U3CsKJvJ1Zqqa+tuAsWvOeA77yC8
         f2Og==
X-Gm-Message-State: APjAAAUklSsMZVSgQoYptpYUoQ3mBOT6k9mxgPmgzuH5/lunY8y4/UCH
        Zq69DyGpbMEtZAi19cCbexs=
X-Google-Smtp-Source: APXvYqyfzlUuV5m88iQ6s9M+IZkWp0j0bN7hq+4Ly5qwzkTH9gGYZXVt1lMVYqQqh3Ri3jBHK0x/kQ==
X-Received: by 2002:a67:bc01:: with SMTP id t1mr16496492vsn.102.1558720674023;
        Fri, 24 May 2019 10:57:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w131sm1448000vsw.7.2019.05.24.10.57.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 10:57:53 -0700 (PDT)
Date:   Fri, 24 May 2019 13:57:52 -0400
Message-ID: <20190524135752.GD17138@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] net: dsa: prepare mv88e6xxx_g1_atu_op() for the
 mv88e6250
In-Reply-To: <20190524085921.11108-3-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-3-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 09:00:26 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> All the currently supported chips have .num_databases either 256 or
> 4096, so this patch does not change behaviour for any of those. The
> mv88e6250, however, has .num_databases == 64, and it does not put the
> upper two bits in ATU control 13:12, but rather in ATU Operation
> 9:8. So change the logic to prepare for supporting mv88e6250.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
