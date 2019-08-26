Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343969D35E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfHZPvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:51:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37094 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfHZPvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:51:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so15848761wrt.4
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 08:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HWCFQn/cYRYFsZ6qifknRkJhCmtGeaI059SRvkJbddU=;
        b=Q+HlI5me6ZWEoos2I8kn3VJQXpVY5v0dP12RTuG7PwJhLblHSPJyVpdt4PTJ85wWc+
         zlhsCzxAF10f1mO6FmK4G7H1MZnsOW3JtgdwI7idp3DnudknIH4G0dRrqfY7obYO+Sw9
         ivwOUvIoK6Y8P+2ZXZC+MWpfCua5zr0cucN8HCFV876DF5hZR4MO+kZ7N/Ej1Sjfwh7D
         5EQqZ8HJqofVKpEM7tjzoylAGqBdM+9Gphazz78rD7lnsPxSsjat3F35ci6QNDSGL0b5
         YJ0ICZOijugZEed9GQRGeQdb3eGt3S4NRGDZBwWQMUOSllj8YRboOGpOzejvmRZIlAsV
         3jEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HWCFQn/cYRYFsZ6qifknRkJhCmtGeaI059SRvkJbddU=;
        b=hbyJZ+5EDPJSnVi9sn+KwxnsTWAaefW3vN/v9KG5lMNT7txisvrPRHvaqvoVnf2tdn
         KYkRImi9/MgEnmm1n5PPlOrtMBy+5VoKhem4niC/MiHxiI+5GuaNsSG/4S+dWU+xdGsy
         HmSxts8qTxTDN67t6nGsMvXpLU/AYzV0QuExHTht1tAU6qvQwZvXefCXwK4m6aHHoCEH
         A1+SDCrAlCcQ1UkwyimflL4VfTd3DVfIHJne2ttY/FebfvQyX5kgYv/F9reQt3iVw2aP
         7wYAfmuK8bPFHq1OdRbx89hpjaorzOXIM7Hmfcs1gtmIu99iHl4IZXw90JBZ62+VuonE
         74dQ==
X-Gm-Message-State: APjAAAV5rhtmgMAFxb/7fBdc1F7g0yMweN9Q6nTu1x3BkDto1WZ/Poab
        ZzJY9+vyEk5QHJtsXNmDWF2HuQ==
X-Google-Smtp-Source: APXvYqzvz4wWnhKM61UMzdg/aOi6H6VXhrJFJwCVIJLyE3SP8c+TjsERXd5BIEMhTDVoxBFdDFMe1w==
X-Received: by 2002:a5d:4dc6:: with SMTP id f6mr23086253wru.209.1566834705433;
        Mon, 26 Aug 2019 08:51:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z12sm11042753wrt.92.2019.08.26.08.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:51:44 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:51:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v3 04/10] net: sched: notify classifier on
 successful offload add/delete
Message-ID: <20190826155144.GD2309@nanopsycho.orion>
References: <20190826134506.9705-1-vladbu@mellanox.com>
 <20190826134506.9705-5-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826134506.9705-5-vladbu@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 26, 2019 at 03:45:00PM CEST, vladbu@mellanox.com wrote:
>To remove dependency on rtnl lock, extend classifier ops with new
>ops->hw_add() and ops->hw_del() callbacks. Call them from cls API while
>holding cb_lock every time filter if successfully added to or deleted from
>hardware.
>
>Implement the new API in flower classifier. Use it to manage hw_filters
>list under cb_lock protection, instead of relying on rtnl lock to
>synchronize with concurrent fl_reoffload() call.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
