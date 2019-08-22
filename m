Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C0E9A408
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfHVXnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:43:08 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43012 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfHVXnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:43:07 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so6727694qkd.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 16:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=6IAoqSyle5y7WqJ3VHFQBAD79ism2OyidY6pg+jZOyQ=;
        b=Hho/JQ+P2hTbjmHpUsPRKZrBG+GYz2wViDUrMJT8YJZQoUE62Xip+CjObGDl5yulfW
         GFc8ivCzlA/9ipOXvTxrFK/SxwkEX8VTMe95aQQA0kkQML1BglXeRc7hQ/PA1cBolmeZ
         fGA4VRUqBUK966Mgnumj10ekzUoJQRn65mR6kPeqrqDfDaDi7ZDirwgPyz3ZgLCVWv9l
         u5ZUy8YTlhEk3dDO9wR7oOu0NxANor/INj+6GN+ngEVDWr4QE+Nh8i4mbQfPXt7wKbzL
         Dq92EvSKml1KJt3OCZnrWmHyiHsV+JQXK3aXesqUY/uKhVIYsg4onJlZbAEYRtVJ7oV+
         sOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=6IAoqSyle5y7WqJ3VHFQBAD79ism2OyidY6pg+jZOyQ=;
        b=YdZ69K6lfT+5uZwuV2YVVFUHjTOop68zOjV8KfY0lSVETOJrGOSzJ6JIIqg/8SrJti
         94+EebdkcEHMpW5xm6kwE/mDv24p4ymjwdy6eiFljYtZ2UI0OmCY696sf/rNXRFR1h+K
         KMOnxjdqjpSwqynylHnGbD/jAkomZ2I34JL5UyJ8cvpX1JxxRP4tdccJT/m79cOsZF11
         EktsREFX9o8LHX8Hk8rSZW7wwX++lKeIGmn5Ur5fhq21XcmP2wIfrFGF8uDQSFJWSRbh
         W1Z6Gg9t5w1/AsB3OxyvxJeAUZ5u+1CZWm3ll6QjvdVDWW9fzLo0NSIWV/qsy6qGkNAM
         v32w==
X-Gm-Message-State: APjAAAXLxA+TSZbZ7aLAw/THaVr07uPxwqBFi4agjrrR68OFyrtm7AaR
        96bJRNAR2bcN74aasTbRO2A=
X-Google-Smtp-Source: APXvYqw+TWe2cnOduv4MIyqUU+xQ/5hC7DNR5cYl6emUyPbafqJdr3XR2XzVOQZu5OqwLzr0SFG95g==
X-Received: by 2002:a05:620a:62b:: with SMTP id 11mr1630058qkv.282.1566517386954;
        Thu, 22 Aug 2019 16:43:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o33sm577693qtd.72.2019.08.22.16.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 16:43:06 -0700 (PDT)
Date:   Thu, 22 Aug 2019 19:43:04 -0400
Message-ID: <20190822194304.GB30912@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 2/6] net: dsa: do not skip -EOPNOTSUPP in
 dsa_port_vid_add
In-Reply-To: <f179fa10-3123-d055-1c67-0d24adf3cb08@gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-3-vivien.didelot@gmail.com>
 <f179fa10-3123-d055-1c67-0d24adf3cb08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, 23 Aug 2019 01:06:58 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Vivien,
> 
> On 8/22/19 11:13 PM, Vivien Didelot wrote:
> > Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.
> > 
> > This function is used in the tag_8021q.c code to offload the PVID of
> > ports, which would simply not work if .port_vlan_add is not supported
> > by the underlying switch.
> > 
> > Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
> > that is to say in dsa_slave_vlan_rx_add_vid.
> > 
> 
> Do you know why Florian suppressed -EOPNOTSUPP in 061f6a505ac3 ("net: 
> dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")?
> I forced a return value of -EOPNOTSUPP here and when I create a VLAN 
> sub-interface nothing breaks, it just says:
> RTNETLINK answers: Operation not supported
> which IMO is expected.

I do not know what you mean. This patch does not change the behavior of
dsa_slave_vlan_rx_add_vid, which returns 0 if -EOPNOTSUPP is caught.


Thanks,

	Vivien
