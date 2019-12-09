Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF27B117B4C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLIXPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:15:50 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39316 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 18:15:49 -0500
Received: by mail-qt1-f195.google.com with SMTP id g1so926183qtj.6
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 15:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=c98cUptVmJxE5gRFF2lQKZ85lSUZABTYRlTJayTa7PU=;
        b=YTeVouU4/q9oN7V71uXAknPNxVcrKdeLiadmUfvC7R1ASQTSCrq+Pr81B2gfXGypD1
         zXYjYZoWD2EYMGFNl0KWPG+93X+2ERGhoESqyBCXQIx/f9vQhccpfNqWvz73GCeEZeRM
         S8NJQwqRpQdm9ZKK8yuqcx/9NeuyYHyfrAnQvVobl8yWvweJg7zAd+6JTna32uoo3QP5
         XaN+X+rWzLzIqSyw+dc1io9te6PAfdjL813YFZcXQSDnttbHyOcVRND/DG5BRabxuAmX
         92Tp3FqR1GSAvRnEOw0azh3nM488Eem7uqoOub0QJmUzOpxDv3kLqbN5/oBCfhkGAf64
         nKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=c98cUptVmJxE5gRFF2lQKZ85lSUZABTYRlTJayTa7PU=;
        b=PQ0HlDNNL3y8KvWBa0+zvOm9Ea1bnyT8VDeK4Axf9NvUmBd21c8PHBEAwPyDuHep1q
         uzIMiqvuMlR2QTGUdAoleqm5P2/Ql95iCr5HM/lHrh4yPz/UNjlQD7zBYqqc5RPFiEvX
         RlDbJHPJhfUncV/k6S+7h13TFyItMmqU9nOpSFh6XiO0bM+vJjKEO0UBFE+HZDhHk3bL
         YlTNPzpNzzgfzh7dvIz/sn7G0CXNvuxggIP2A+0luKYqX4CwxbXzE5m5ktSS1tGeyvui
         w7A6FXYU9KTAzMHDwycIaPxjQkqJd233CvW8pUUzYZ0qug9UOQkr3dESiw0zZYPliSzt
         Y7tw==
X-Gm-Message-State: APjAAAWTjWSzIlHicFb8ChwzkZGYbOUQqf7zPklbxIAR8OgsO9dXa36d
        0C2WgqQ/cSpSGpGd96PBuKaN/j0hUCw=
X-Google-Smtp-Source: APXvYqx87azaFPi5Z71WjpcRREL+sPda6Ebwe2n8koNLtli8Ibd7oYhajwkSAFOe8Q6VRBz0YyNwSQ==
X-Received: by 2002:aed:3c5b:: with SMTP id u27mr27822071qte.287.1575933348984;
        Mon, 09 Dec 2019 15:15:48 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id h28sm339600qkk.48.2019.12.09.15.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 15:15:47 -0800 (PST)
Date:   Mon, 9 Dec 2019 18:15:47 -0500
Message-ID: <20191209181547.GB1256102@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH iproute2] iplink: add support for STP xstats
In-Reply-To: <20191209143423.7acb2f4b@hermes.lan>
References: <20191209211841.1239497-1-vivien.didelot@gmail.com>
 <20191209211841.1239497-2-vivien.didelot@gmail.com>
 <20191209143423.7acb2f4b@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 14:34:23 -0800, Stephen Hemminger <stephen@networkplumber.org> wrote:
> On Mon,  9 Dec 2019 16:18:41 -0500
> Vivien Didelot <vivien.didelot@gmail.com> wrote:
> 
> > diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> > index 31fc51bd..e7f2bb78 100644
> > --- a/include/uapi/linux/if_bridge.h
> > +++ b/include/uapi/linux/if_bridge.h
> 
> These headers are semi-automatically updated from the kernel.
> Do not make changes here.

OK, I respin the series with only the minimal changes required for iproute2
to compile correctly.

Thank you,
Vivien
