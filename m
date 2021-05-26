Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B67391674
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhEZLrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbhEZLro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:47:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5057C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 04:46:12 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t193so728849pgb.4
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 04:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=aTN92FwpPIQA94uccxXmGO5bXEcq9h+0WhUYXgbu+QY=;
        b=QuHT5vZ9y/u8PXSCCDOTYKXPOAI4sFhY1ilP8IsPCrKfHqd8c4Zq/iWT2ao4LWsbdI
         R0tGw31SmJKigHt6BWjN4d2U9RRJFTduRp27OMC7DYgAJdmFFjoypLvAQKWSLX45GvJ1
         aLxXAHAl41qhGC8gKZyltONdiQqY/cASiYRWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=aTN92FwpPIQA94uccxXmGO5bXEcq9h+0WhUYXgbu+QY=;
        b=rTmgGIaKTxEzxMOYDHQm/OXBJC81afE2Ho0iUO7rZhlR5cKm8zuXWmTajRtjeK89H3
         1660FpsrhSx/JbUpudzKPWBzST90YwpYr/EdzJRXZLUik4e4Q3Hx6sSuIY81t3iHP21G
         1eBjWCijHV8E4q074x5RjtnQYYCsFfwprsntv+cIlrbEOd5P9T/Dug3nYCa3zinV1K1U
         eINZ94ZcC45aXAyPKi1bLR0gHgmMVIlIqsy1ugk/9kcQz7gAT5PAb8FjhJla8qL+072t
         TU8l+2H/N9P20nXAswkvtCk64oUrBCtO6gG3ftvfcnK3iDiqLxQ3kco5TP+SBa/GFTfA
         aN0Q==
X-Gm-Message-State: AOAM533h09fCoL+kh8RMstm35Vn1D4FM5nNqq3CclGfML3+xju4RJbVa
        3SRZzPzYCENg6IH/v6ZrS8kFMA==
X-Google-Smtp-Source: ABdhPJyPy51zz9iflf72W+uVEKsO3fqcmBRpVz7emqJeY+dQisL6tGgqLboNpBYPsqXrzQzH4lVHSQ==
X-Received: by 2002:a62:7dc1:0:b029:2de:275a:9ce9 with SMTP id y184-20020a627dc10000b02902de275a9ce9mr9744864pfc.42.1622029572266;
        Wed, 26 May 2021 04:46:12 -0700 (PDT)
Received: from builder ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id m5sm16030879pgl.75.2021.05.26.04.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 04:46:11 -0700 (PDT)
Date:   Wed, 26 May 2021 14:45:53 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/3] net/sched: act_vlan: Fix modify to allow
 0
Message-ID: <20210526114553.GA31019@builder>
References: <20210525153601.6705-1-boris.sukholitko@broadcom.com>
 <20210525153601.6705-2-boris.sukholitko@broadcom.com>
 <YK1fpkmyiITfaVpr@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
In-Reply-To: <YK1fpkmyiITfaVpr@dcaratti.users.ipa.redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007ef26205c33a3038"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007ef26205c33a3038
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Davide,

On Tue, May 25, 2021 at 10:35:50PM +0200, Davide Caratti wrote:
> On Tue, May 25, 2021 at 06:35:59PM +0300, Boris Sukholitko wrote:
[snip]
> 
> > @@ -121,6 +121,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
> >  	struct tc_action_net *tn = net_generic(net, vlan_net_id);
> >  	struct nlattr *tb[TCA_VLAN_MAX + 1];
> >  	struct tcf_chain *goto_ch = NULL;
> > +	bool push_prio_exists = false;
> >  	struct tcf_vlan_params *p;
> >  	struct tc_vlan *parm;
> >  	struct tcf_vlan *v;
> > @@ -189,7 +190,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
> >  			push_proto = htons(ETH_P_8021Q);
> >  		}
> >  
> > -		if (tb[TCA_VLAN_PUSH_VLAN_PRIORITY])
> > +		push_prio_exists = !!tb[TCA_VLAN_PUSH_VLAN_PRIORITY];
> 
> when the VLAN tag is pushed, not modified, the value of 'push_prio' is
> used in the traffic path regardless of the true/false value of
> 'push_prio_exists'. See below:
> 
>  50         case TCA_VLAN_ACT_PUSH:
>  51                 err = skb_vlan_push(skb, p->tcfv_push_proto, p->tcfv_push_vid |
>  52                                     (p->tcfv_push_prio << VLAN_PRIO_SHIFT));
> 

Yes, the tcfv_push_prio is 0 here by default.

> So, I think that 'p->push_prio_exists' should be identically set to
> true when 'v_action' is TCA_VLAN_ACT_PUSH. That would allow a better
> display of rules once patch 2 of your series is applied: otherwise,
> 2 rules configuring the same TCA_VLAN_ACT_PUSH rule would be displayed
> differently, depending on whether userspace provided or not the
> TCA_VLAN_PUSH_VLAN_PRIORITY attribute set to 0.

Sorry for being obtuse, but I was under impression that we want to
display priority if and only if it has been set by the userspace.
Therefore the fact that the default vlan priority for the push is 0 has
no relevance to such logic.

Why do you think that the push should be made special regarding the
display? Is there something I am missing here?

Thanks,
Boris.

> In other words, the last hunk should be something like:
> 
> @@ -241,6 +243,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
>  	p->tcfv_action = action;
>  	p->tcfv_push_vid = push_vid;
>  	p->tcfv_push_prio = push_prio;
> +	p->tcfv_push_prio_exists = push_prio_exists || action == TCA_VLAN_ACT_PUSH;
> 
> 
> WDYT?
> 
> thanks!
> -- 
> davide
> 

--0000000000007ef26205c33a3038
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDDSzinKpvcPTN4ZIJTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNzMwMDRaFw0yMjA5MDUwNzM3NTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAy/C7bjpxs+95egWV8sWrK9KO0SQi6Nxu14tJBgP+MOK5tvokizPFHoiXTymZ
7ClfnmbcqT4PzWgI3thyfk64bgUo1nQkCTApn7ov3IRsWjmHExLSNoJ/siUHagO6BPAk4JSycrj5
9tC9sL4FnIAbAHmOSILCyGyyaBAcmiyH/3toYqXyjJkK+vbWQSTxk2NlqJLIN/ypLJ1pYffVZGUs
52g1hlQtHhgLIznB1Qx3Fop3nOUk8nNpQLON/aM8K5sl18964c7aXh7YZnalUQv3md4p2rAQQqIR
rZ8HBc7YjlZynwOnZl1NrK4cP5aM9lMkbfRGIUitHTIhoDYp8IZ1dwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtBmGs9S4
t1FcFSfkrP2LKQQwBKMwDQYJKoZIhvcNAQELBQADggEBAJMAjVBkRmr1lvVvEjMaLfvMhwGpUfh6
CMZsKICyz/ZZmvTmIZNwy+7b9r6gjLCV4tP63tz4U72X9qJwfzldAlYLYWIq9e/DKDjwJRYlzN8H
979QJ0DHPSJ9EpvSKXob7Ci/FMkTfq1eOLjkPRF72mn8KPbHjeN3VVcn7oTe5IdIXaaZTryjM5Ud
bR7s0ZZh6mOhJtqk3k1L1DbDTVB4tOZXZHRDghEGaQSnwU/qxCNlvQ52fImLFVwXKPnw6+9dUvFR
ORaZ1pZbapCGbs/4QLplv8UaBmpFfK6MW/44zcsDbtCFfgIP3fEJBByIREhvRC5mtlRtdM+SSjgS
ZiNfUggxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw0
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFrbRkKyMJyulWW4
fYJ+YF0VoMOfXVDXDJWbIIHWlQydMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDUyNjExNDYxMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAgOYs1MekBkkne6MOyGKY93ZJV7rnzHlsw
lLr5/MhZEli2EL1ixtKPTUiXa3xtF35OR9A6j8MhupC9/ArFxc6puCnA56LiREjEH1QN7PY+ekLy
caJnwuy0BNVuTKhS0IRyF5bFYVDLPs5o29/AH9pjbcmUNvnnkJvXXsQoos4+5XT9uplAXjLSAyDH
iyQYZ0KkTYT6jAdivUdcb8TDYWLALb3L17ekEFYtXYfY2OD80DaeHRsU/ULdgb7B9hDUWTaU7gSm
HUwf32sYWYgGgN5Qf4bzGUcIa57qJIjMKcw/dx7Et2mjKreV8TGzVNNDe3IG+D+sCULVjLDyCF0v
QB8s
--0000000000007ef26205c33a3038--
