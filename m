Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A8821C88E
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 12:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgGLK3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 06:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGLK3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 06:29:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906D9C061794;
        Sun, 12 Jul 2020 03:29:46 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594549781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IWFrAeJzdC1u5O59YIvI89feeTzWtk1CrA2wzI7B5gE=;
        b=PSp9tjkUXphkpck6Gxdu/lMEZw5gF0vW38et/aNTdWMOLb+5CmmzJCc6n1n84uBxWDId5X
        Fzn5t+XBKdd5iHG2y3bRdAiQSDaKkGImtNi/1QuI7LVA7KtDnmxsVU0LxCbogHpExTzNwJ
        lYiMUCQEMoWWlD2E83VpGi3VHAVGKmqgCJxbAbztoBpUF7NsafpZI/uohat3Vm5R4YsuD9
        4xOlYlnZ1OyVY0Dxf7CjGOLSE6nyxglV5Rdc5DR9Kn8IS9STCzRhHHjwN8BJXW4CE5Emle
        2rUCVvvHOJc7iBf/WWU5s7Za8lm+9Moi1siZ5tgTkVig1ddMACL7lrB3MiVF7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594549781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IWFrAeJzdC1u5O59YIvI89feeTzWtk1CrA2wzI7B5gE=;
        b=VMpQ130axs2hwnRSwQ/bqxaQQc3ST3nKEbRBB8nfn4ZY9LkIav224V3zoPMikeu5qmE+yL
        Qp1rVKb/NkvfLDDg==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
In-Reply-To: <20200711165203.GO1014141@lunn.ch>
References: <20200710090618.28945-1-kurt@linutronix.de> <20200710090618.28945-2-kurt@linutronix.de> <20200710163940.GA2775145@bogus> <874kqewahb.fsf@kurt> <20200711165203.GO1014141@lunn.ch>
Date:   Sun, 12 Jul 2020 12:29:30 +0200
Message-ID: <877dv9owl1.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Jul 11 2020, Andrew Lunn wrote:
> On Sat, Jul 11, 2020 at 01:35:12PM +0200, Kurt Kanzenbach wrote:
>> On Fri Jul 10 2020, Rob Herring wrote:
>> > My bot found errors running 'make dt_binding_check' on your patch:
>> >
>> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/n=
et/ti,cpsw-switch.example.dt.yaml: switch@0: 'ports' is a required property
>> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/n=
et/qcom,ipq8064-mdio.example.dt.yaml: switch@10: 'ports' is a required prop=
erty
>>=20
>> Okay, the requirement for 'ports' has be to removed.
>
> Hummm....
>
> ti.cpsw is not a DSA switch. So this binding should not apply to
> it. It is a plain switchdev switch.
>
> The qcom,ipq806 is just an MDIO bus master. The DSA binding might
> apply, for a specific .dts file, if that dts file has a DSA switch on
> the bus. But in general, it should not apply.
>
> So i actually think you need to work out why this binding is being
> applied when it should not be.
>
> I suspect it is the keyword 'switch'. switch does not imply it is a
> DSA switch. There are other sorts of switches as well.

OK, makes sense. It seems like the nodename is responsible for that.

This fixes the problem:

|diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Document=
ation/devicetree/bindings/net/dsa/dsa.yaml
|index bec257231bf8..4c360f8b170e 100644
|--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
|+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
|@@ -18,9 +18,6 @@ description:
|   properties as required by the device it is embedded within.
|=20
| properties:
|-  $nodename:
|-    pattern: "^switch(@.*)?$"
|-
|   dsa,member:
|     minItems: 2
|     maxItems: 2

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8K5goACgkQeSpbgcuY
8KYE0RAAzpJZjOmKWljpOO5oKYziFmhkV7L3HXbG53rkVv6YbcpuETjWW+UrbEjZ
XHLxvRFETuQgOrH8bEUWXbom6h0fv7HIUi/On3DSlajPRfyuSzMw7AYMi99wNM0F
3eVk8f1+ftLDZNEdbcigZYU+ZuCFXlnuelqvq9JzYBps44M18Cdc1DlddNNTy/jo
/qDtNtHmQxjcxXPDW6LDJn+WnsQlo8Fxz7Se+8/jNHz8NV+b5Hi33m0aevkZwK1R
bsby9RgIuhbSOg8hlM98KCkowcRT0aNoyMsiy+luoTxEAJOA/QQJ3w0zgdT3+bT9
7uq0EvdkNtXvbXNVej3FbcxS/9636ZkCEmHCz8EAVbZ7q4WLU2+f801HQ3m21hRO
7Szad+gXUHkIRP/xGdfZFhGV7snsWKEn13VufmnO5dHz+xVLI39obr0TekbWEjfw
4H2OaLvnmgGRJlxluH27xDu379IUxYO6lqy+fIpb4WDHiQryjOe2kY14q0hEERKi
M133gk+DWheg/OrgIPybPHliHrjPO1Egx8N1Lf7fW3HHjA2aRrEpnkrZNDitjXRx
cJL1DnDDQNp7GUx1aGJJLKISZBMLz/MePwhp6uUAiFeVLEmnk5oGt8joqnMbO0Q4
TVlzaKEyLdIWtfmc6EJTrRa9NPUYo3BfC8zrupljlcWLxAAQM/Q=
=1pvc
-----END PGP SIGNATURE-----
--=-=-=--
