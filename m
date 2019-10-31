Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5921CEA929
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfJaCOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:14:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45314 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfJaCOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:14:30 -0400
Received: by mail-qk1-f195.google.com with SMTP id q70so5215781qke.12;
        Wed, 30 Oct 2019 19:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=nAtFBaF759uCGM4rCo8bYpeccOLVNQhATaaIk5meiKI=;
        b=c3PocsTubGHZc+Vdfn1oU6/MMIpEZbErwAP34Q4VEp2CMaXUWioeVpLJbmFYdo180W
         q8A6evE++Vj4HbXUb+1sIVXG75FoUAuhADZzeD0vvBrQS0OXlgta9T/bmH0uk9iPUttu
         PQ/WCJpcJp5dBi/XL9sKlsVQcNWMgIP72dHcX8WoMkqwakTY8I5HMhaYgsjQVZV7ZZB7
         UAQqnzLp/24K0TrtcHNa6hje2aoicLTV6EKpp52n/cYwwhWsGrK0ges2rT88Rc5cGVCb
         ho6eCGyJ+ntuG9LIiJYOlzrSzqOLFjTZjVdSQjsdmGFNJ0zWh/8H9X+mwK2ViAu3x+fV
         1TPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=nAtFBaF759uCGM4rCo8bYpeccOLVNQhATaaIk5meiKI=;
        b=FueFiP8u5iDBoUEq+7JSJD0OweTr6xRyBjoesCaIqRRZBMiCZmsb9xZXkEOgQkOGRT
         gPss0vSAKFizZjvWpDVi0GmEy15oFcdYOOS0a5Boy//Lyym67dGMVpDr3WchaN1to171
         7NZhI4rS4pUWIca2eOFVHr00Q8KUcGIJxv31oAtHSJqQz7RFYxDJbYeel2uLr2XjI9as
         psKAdTZjNDExO/JkwqMSFSHkRMwjlfBYLOCSXhjb56+RXX+eVTwpS2vdsBCKlcleXHTS
         W69nPc5kLmJGQPuuFs5uvm2F5iT3V1a4ZnfMTiszsPx/EFmD97+3JzU4JQTwzDD4WeYR
         3DKQ==
X-Gm-Message-State: APjAAAVcgw9EvoEzK9TVFvIdz/SFLll2TzKG2F2OOmMYPAZt9ASkhFfP
        Gru8qVBeq6GVxWrcPShY7ys=
X-Google-Smtp-Source: APXvYqzjo/p8HCl6UKJSGUhDB6LDokrTpabXxMymCS2wsR5V9Ho4W2xvcr/9noLUPmmksNNcd5FZUg==
X-Received: by 2002:a05:620a:1010:: with SMTP id z16mr3126971qkj.496.1572488069580;
        Wed, 30 Oct 2019 19:14:29 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id v54sm1145242qtc.77.2019.10.30.19.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:14:29 -0700 (PDT)
Date:   Wed, 30 Oct 2019 22:14:28 -0400
Message-ID: <20191030221428.GB140471@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: dsa: list DSA links in the fabric
In-Reply-To: <20191030.143949.809392632168787466.davem@davemloft.net>
References: <20191028195220.2371843-1-vivien.didelot@gmail.com>
 <20191028195220.2371843-2-vivien.didelot@gmail.com>
 <20191030.143949.809392632168787466.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, 30 Oct 2019 14:39:49 -0700 (PDT), David Miller <davem@davemloft.net> wrote:
> From: Vivien Didelot <vivien.didelot@gmail.com>
> Date: Mon, 28 Oct 2019 15:52:14 -0400
> 
> > @@ -122,6 +124,29 @@ static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
> >  	return NULL;
> >  }
> >  
> > +struct dsa_link *dsa_link_touch(struct dsa_port *dp, struct dsa_port *link_dp)
> > +{
> > +	struct dsa_switch *ds = dp->ds;
> > +	struct dsa_switch_tree *dst = ds->dst;
> > +	struct dsa_link *dl;
> 
> Please fix the reverse christmas tree here, two suggestions:
> 
> 	struct dsa_switch *ds = dp->ds;
> 	struct dsa_switch_tree *dst;
> 	struct dsa_link *dl;
> 
> 	dst = ds->dst;
> 
> Or, alternatively, since the dst variable is used only once, get rid of it
> and change:
> 
> > +	list_add_tail(&dl->list, &dst->rtable);
> 
> to
> 
> > +	list_add_tail(&dl->list, &ds->dst->rtable);

No problem, I've sent a v2 using the first suggestion, since dst is in fact
used twice in this function.


Thank you,

	Vivien
